import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/main.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/utils/error_helper.dart';
import 'package:secure_me/view/common/app_snackbar.dart';

class OtpController extends GetxController {
  var otp = "".obs;
  var isLoading = false.obs;
  var identifier = "".obs;
  var isPhone = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['email'] != null) {
        identifier.value = args['email'];
        isPhone.value = false;
      } else if (args['phone'] != null) {
        identifier.value = args['phone'];
        isPhone.value = true;
      }
      dev.log('📱 Identifier received: ${identifier.value}', name: 'OtpController');
    }
  }

  void setOtp(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      AppSnackbar.show(title: "Error", message: "Please enter 6 digit OTP", isError: true);
      return;
    }

    isLoading.value = true;
    dev.log('🔄 Verifying OTP for: ${identifier.value}', name: 'OtpController');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
        isPhone.value ? "phone" : "email": identifier.value, 
        "otp": otp.value
      }),
      );

      isLoading.value = false;

      dev.log(
        "📡 Verify OTP Response Status: ${response.statusCode}",
        name: 'OtpController',
      );
      dev.log(
        "📡 Verify OTP Response Body: ${response.body}",
        name: 'OtpController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          dev.log(
            '✅ OTP verified successfully for: ${identifier.value}',
            name: 'OtpController',
          );

          dev.log(
            '🔍 Checking user data in OTP response...',
            name: 'OtpController',
          );
          dev.log('🔍 Full data object: $data', name: 'OtpController');
          dev.log('🔍 Data keys: ${data.keys}', name: 'OtpController');

          // Try to find token in different locations
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
            dev.log('✅ Found token at data["token"]', name: 'OtpController');
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
            dev.log(
              '✅ Found token at data["data"]["token"]',
              name: 'OtpController',
            );
          }

          // Try to find user in different locations
          if (data['user'] != null) {
            user = data['user'];
            dev.log('✅ Found user at data["user"]', name: 'OtpController');
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
            dev.log(
              '✅ Found user at data["data"]["user"]',
              name: 'OtpController',
            );
          }

          dev.log('🔍 Token found: ${token != null}', name: 'OtpController');
          dev.log('🔍 User found: ${user != null}', name: 'OtpController');

          if (user != null && token != null) {
            dev.log('🔍 User object: $user', name: 'OtpController');
            dev.log('🔍 User keys: ${user.keys}', name: 'OtpController');

            // Use centralized saveUserData method which creates session automatically
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
              profileImage: user['profile_image'],
              userRole: user['user_role'] ?? user['role'] ?? 'user',
            );

             // Update AuthController state
             if (Get.isRegistered<AuthController>()) {
                final auth = Get.find<AuthController>();
                 final roleStr = (user['user_role'] ?? user['role'])?.toString() ?? 'Manager';
                 final normalizedRole = roleStr.toLowerCase();
                 UserRole role;
                 
                 if (normalizedRole.contains('gym')) {
                   role = UserRole.Gym_Person;
                 } else if (normalizedRole.contains('police')) {
                   role = UserRole.Police;
                 } else {
                   role = UserRole.Manager;
                 }

                auth.user.value = UserModel(
                  id: user['id']?.toString() ?? '',
                  name: user['name'] ?? 'Verified User',
                  email: user['email'] ?? '',
                  phone: (user['phone_no'] ?? user['phone']) ?? '',
                  role: role,
                  roleString: roleStr,
                  profileImage: user['profile_image'],
                );
             }

            dev.log(
              '✅ All user data and session saved successfully',
              name: 'OtpController',
            );
          } else {
            dev.log(
              '⚠️ Missing user object or token in OTP API response!',
              name: 'OtpController',
            );

            // Fallback: save token only if available
            if (token != null) {
              await PreferenceHelper.saveToken(token);
              await PreferenceHelper.saveLoginStatus(true);
              dev.log('✅ Token saved from fallback', name: 'OtpController');
            }
          }

          AppSnackbar.show(
            title: "Success",
            message: data['message'] ?? "OTP verified successfully",
            isSuccess: true,
          );

          dev.log('🚀 Navigating via AppRouter', name: 'OtpController');
          Get.offAll(() => AppRouter());
        } else {
          dev.log(
            '❌ OTP verification failed: ${data['message']}',
            name: 'OtpController',
          );
          AppSnackbar.show(
            title: "Error",
            message: data['message'] ?? "Invalid OTP",
            isError: true,
          );
        }
      } else if (response.statusCode == 401) {
        dev.log(
          '❌ Unauthorized: Invalid or expired OTP',
          name: 'OtpController',
        );
        AppSnackbar.show(
          title: "Error",
          message: "Invalid or expired OTP",
          isError: true,
        );
      } else {
        dev.log(
          '❌ Verification failed with status: ${response.statusCode}',
          name: 'OtpController',
        );
        AppSnackbar.show(
          title: ErrorHelper.getErrorTitle(response.statusCode),
          message: ErrorHelper.getFriendlyMessage(response),
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log("❌ Verify OTP Error: $e", name: 'OtpController');
      AppSnackbar.show(
        title: "Error",
        message: "Network error. Please check your connection and try again.",
        isError: true,
      );
    }
  }

  Future<void> resendOtp() async {
    if (identifier.value.isEmpty) {
      AppSnackbar.show(
        title: "Error",
        message: "${isPhone.value ? 'Phone' : 'Email'} not found",
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    dev.log('🔄 Resending OTP to: ${identifier.value}', name: 'OtpController');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.resendOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({isPhone.value ? "phone" : "email": identifier.value}),
      );

      isLoading.value = false;

      dev.log(
        "📡 Resend OTP Response Status: ${response.statusCode}",
        name: 'OtpController',
      );
      dev.log(
        "📡 Resend OTP Response Body: ${response.body}",
        name: 'OtpController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          dev.log(
            '✅ OTP resent successfully to: ${identifier.value}',
            name: 'OtpController',
          );

          AppSnackbar.show(
            title: "Success",
            message: data['message'] ?? "OTP sent successfully",
            isSuccess: true,
          );
        } else {
          dev.log(
            '❌ Failed to resend OTP: ${data['message']}',
            name: 'OtpController',
          );
          AppSnackbar.show(
            title: "Error",
            message: data['message'] ?? "Failed to resend OTP",
            isError: true,
          );
        }
      } else {
        dev.log(
          '❌ Resend OTP failed with status: ${response.statusCode}',
          name: 'OtpController',
        );
        AppSnackbar.show(
          title: ErrorHelper.getErrorTitle(response.statusCode),
          message: ErrorHelper.getFriendlyMessage(response),
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log("❌ Resend OTP Error: $e", name: 'OtpController');
      AppSnackbar.show(
        title: "Error",
        message: "Network error. Please check your connection and try again.",
        isError: true,
      );
    }
  }
}

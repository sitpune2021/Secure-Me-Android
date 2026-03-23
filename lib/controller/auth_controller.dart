import 'package:get/get.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:flutter/material.dart'; // Added for TextEditingController

class AuthController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // New fields for managing login/registration state
  UserRole _selectedRole = UserRole.user; // Default role
  bool _isPhoneLogin = false; // Tracks if the user is trying to login with phone
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Getters for the new fields
  UserRole get selectedRole => _selectedRole;
  bool get isPhoneLogin => _isPhoneLogin;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;

  // Setters for the new fields
  void setSelectedRole(UserRole role) {
    _selectedRole = role;
    update(); // Notify listeners if this controller is used in a GetBuilder
  }

  void toggleLoginMethod() {
    _isPhoneLogin = !_isPhoneLogin;
    update(); // Notify listeners
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserSession();
  }

  void _loadUserSession() async {
    final token = await PreferenceHelper.getToken();
    if (token != null) {
       // Mock loading user from preferences
       // In a real app, you would fetch user data from an API or local DB
       user.value = UserModel(
         id: '1',
         name: 'Loaded User',
         email: 'user@example.com',
         phone: '1234567890',
         role: UserRole.user,
       );
    }
  }

  @override
  void onClose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.onClose();
  }

  void login(String email, String password, UserRole role) async {
    isLoading.value = true;
    // Mock Login delay
    await Future.delayed(const Duration(seconds: 1));
    
    user.value = UserModel(
      id: '1',
      name: 'Mock ${role.name.toUpperCase()}',
      email: email,
      phone: '1234567890',
      role: role,
    );
    
    // Switch theme for the role
    Get.changeTheme(AppTheme.getThemeForRole(role.name));
    isLoading.value = false;
  }

  void sendPhoneOtp(String phone, UserRole role) async {
    isLoading.value = true;
    // Mock OTP sending delay
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar(
      "OTP Sent", 
      "A verification code has been sent to $phone",
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
    );
    isLoading.value = false;
    
    // Navigate to OTP Screen
    Get.toNamed('/otp', arguments: {'phone': phone, 'role': role});
  }

  void verifyPhoneOtp(String otp, String phone, UserRole role) async {
    isLoading.value = true;
    // Mock OTP verification delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful verification
    user.value = UserModel(
      id: '2',
      name: 'User $phone',
      email: 'verified@secureme.com',
      phone: phone,
      role: role,
    );
    
    Get.changeTheme(AppTheme.getThemeForRole(role.name));
    isLoading.value = false;
    Get.offAllNamed('/'); // Navigate to home
  }

  void logout() {
    user.value = null;
    Get.changeTheme(AppTheme.getThemeForRole('user'));
  }
}

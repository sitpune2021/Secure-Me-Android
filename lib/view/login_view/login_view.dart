import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: themeController.theme.colorScheme.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.025),

                          // Title
                          Text(
                            "Login Account",
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.07,
                              color: themeController
                                  .theme
                                  .colorScheme
                                  .onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.005),

                          Text(
                            "Welcome back",
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.045,
                              color: themeController
                                  .theme
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                          ),

                          SizedBox(height: Get.height * 0.05),

                          // Login Image
                          Center(
                            child: Image.asset(
                              'assets/images/login.png',
                              height: Get.height * 0.3,
                              width: Get.width * 0.4,
                            ),
                          ),

                          SizedBox(height: Get.height * 0.02),

                          // Mobile Number Label
                          Text(
                            "Mobile Number",
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: themeController
                                  .theme
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.01),

                          // Mobile TextField
                          TextField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                              hintStyle: GoogleFonts.poppins(
                                color: AppTheme.loginHintTextColor(isDark),
                              ),
                              filled: true,
                              fillColor: AppTheme.loginTextFieldBg(isDark),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppTheme.loginTextFieldBg(isDark),
                                ),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              color: AppTheme.loginTextColor(isDark),
                            ),
                            onChanged: (val) {
                              controller.mobileNumber.value = val;
                              if (val.length == 10)
                                FocusScope.of(context).unfocus();
                            },
                          ),

                          SizedBox(height: Get.height * 0.02),

                          // Keep me logged in checkbox
                          Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  value: controller.keepLoggedIn.value,
                                  onChanged: controller.toggleKeepLoggedIn,
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) => isDark
                                        ? AppColors.darkRadialGlow
                                        : AppColors.lightPrimary,
                                  ),
                                  checkColor: isDark
                                      ? AppColors.darkHint
                                      : AppColors.lightHint,
                                ),
                                Text(
                                  "Keep me logged in",
                                  style: GoogleFonts.poppins(
                                    color: themeController
                                        .theme
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: Get.height * 0.05),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: Get.height * 0.07,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.loginButtonBackground(
                                  isDark,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (mobileController.text.length != 10) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter a valid 10-digit mobile number",
                                    backgroundColor: AppColors.snackBarBg(
                                      isDark,
                                    ),
                                    colorText: AppColors.snackBarText(isDark),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else {
                                  controller.login();
                                }
                              },
                              child: Text(
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: Get.width * 0.05,
                                  color: AppTheme.loginTextColor(isDark),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: Get.height * 0.03),

                          // OR separator
                          Center(
                            child: Text(
                              'OR',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppTheme.loginHintTextColor(isDark),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          SizedBox(height: Get.height * 0.01),

                          // Create Account Button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.registerView);
                              },
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: AppTheme.loginTextColor(isDark),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

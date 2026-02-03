import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PermissionController permissionController = Get.put(
    PermissionController(),
  );

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      //permissionController.requestAllPermissions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: themeController.theme.colorScheme.surface,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        // ---------------- BACKGROUND IMAGE ----------------
                        Positioned.fill(
                          child: Opacity(
                            opacity: isDark
                                ? 0.22
                                : 0.55, // darker in dark mode, lighter in light mode
                            child: Image.asset(
                              isDark
                                  ? "assets/images/bg_dark.png" // the purple neon girl
                                  : "assets/images/bg_light.png", // the bright soft girl
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // ---------------- MAIN CONTENT ----------------
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.05,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.022),

                              // Title
                              Center(
                                child: Text(
                                  "Login Account",
                                  style: GoogleFonts.poppins(
                                    fontSize: isDark
                                        ? 34
                                        : 32, // Login Account (bold)

                                    fontWeight: FontWeight.w600,
                                    color: AppColors.loginTitleColor(isDark),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.005),

                              Center(
                                child: Text(
                                  "Welcome back",
                                  style: GoogleFonts.poppins(
                                    fontSize: isDark ? 21 : 20, // Welcome back
                                    // Login Account (bold)
                                    color: AppColors.welcomeTextColor(isDark),
                                  ),
                                ),
                              ),

                              SizedBox(height: Get.height * 0.15),

                              // Image (unchanged)
                              Center(
                                child: Container(
                                  width: Get.width * .28,
                                  height: Get.width * .28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.loginIconCircle(isDark),
                                  ),
                                  child: Icon(
                                    RemixIcons.user_3_line,
                                    size: Get.width * .18,
                                    color: AppColors.loginIconSymbol(isDark),
                                  ),
                                ),
                              ),

                              SizedBox(height: Get.height * 0.06),

                              // Tabs
                              Obx(
                                () => Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2C2C2C)
                                        : const Color(0xFFF2F4F5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              controller.isEmailLogin.value =
                                                  true,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.isEmailLogin.value
                                                  ? (isDark
                                                        ? const Color(
                                                            0xFF424242,
                                                          )
                                                        : Colors.white)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow:
                                                  controller.isEmailLogin.value
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                        blurRadius: 4,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Text(
                                              "Email",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color:
                                                    controller
                                                        .isEmailLogin
                                                        .value
                                                    ? (isDark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF6C757D,
                                                            ))
                                                    : (isDark
                                                          ? Colors.white54
                                                          : const Color(
                                                              0xFFAAB8C2,
                                                            )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              controller.isEmailLogin.value =
                                                  false,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  !controller.isEmailLogin.value
                                                  ? (isDark
                                                        ? const Color(
                                                            0xFF424242,
                                                          )
                                                        : Colors.white)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow:
                                                  !controller.isEmailLogin.value
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                        blurRadius: 4,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Text(
                                              "Mobile",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color:
                                                    !controller
                                                        .isEmailLogin
                                                        .value
                                                    ? (isDark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF6C757D,
                                                            ))
                                                    : (isDark
                                                          ? Colors.white54
                                                          : const Color(
                                                              0xFFAAB8C2,
                                                            )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Form Fields
                              Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.isEmailLogin.value) ...[
                                      // EMAIL LOGIN
                                      Text(
                                        "Email",
                                        style: GoogleFonts.poppins(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                              .theme
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                      TextField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: "Enter Email",
                                          hintStyle: GoogleFonts.poppins(
                                            color: AppTheme.loginHintTextColor(
                                              isDark,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppTheme.loginTextFieldBg(
                                            isDark,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.loginTextColor(
                                            isDark,
                                          ),
                                        ),
                                        onChanged: (val) =>
                                            controller.email.value = val,
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                      Text(
                                        "Password",
                                        style: GoogleFonts.poppins(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                              .theme
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: "Enter Password",
                                          hintStyle: GoogleFonts.poppins(
                                            color: AppTheme.loginHintTextColor(
                                              isDark,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppTheme.loginTextFieldBg(
                                            isDark,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.loginTextColor(
                                            isDark,
                                          ),
                                        ),
                                        onChanged: (val) =>
                                            controller.password.value = val,
                                      ),
                                    ] else ...[
                                      // PHONE LOGIN
                                      Text(
                                        "Mobile Number",
                                        style: GoogleFonts.poppins(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: themeController
                                              .theme
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                      TextField(
                                        controller: mobileController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Enter Mobile Number",
                                          hintStyle: GoogleFonts.poppins(
                                            color: AppTheme.loginHintTextColor(
                                              isDark,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppTheme.loginTextFieldBg(
                                            isDark,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.loginTextColor(
                                            isDark,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          controller.mobileNumber.value = val;
                                          if (val.length == 10) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              SizedBox(height: Get.height * 0.02),

                              // Keep me logged in checkbox
                              Obx(
                                () => Row(
                                  children: [
                                    Checkbox(
                                      value: controller.keepLoggedIn.value,
                                      onChanged: controller.toggleKeepLoggedIn,
                                      fillColor:
                                          WidgetStateProperty.resolveWith(
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
                                            .onSurface,
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
                                child: Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.loginButtonBackground(
                                            isDark,
                                          ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () {
                                            controller.login();
                                          },
                                    child: controller.isLoading.value
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppTheme.loginTextColor(
                                                      isDark,
                                                    ),
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            "Log In",
                                            style: GoogleFonts.poppins(
                                              fontSize: Get.width * 0.05,
                                              color: AppTheme.loginTextColor(
                                                isDark,
                                              ),
                                            ),
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
                      ],
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

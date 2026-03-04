import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
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

  // Password visibility toggle
  bool obscurePassword = true;

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
              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
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
                                child: Column(
                                  children: [
                                    Text(
                                      "Login Account",
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppColors.darkText
                                            : AppColors.lightText,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Welcome back to SecureMe",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color:
                                            (isDark
                                                    ? AppColors.darkText
                                                    : AppColors.lightText)
                                                .withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: Get.height * 0.15),

                              // Improved User Icon with Glow
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Multiple Glow Layers (similar to RegisterView for consistency)
                                    Container(
                                      width: Get.width * 0.45,
                                      height: Get.width * 0.45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            (isDark
                                                    ? AppColors.darkRadialGlow
                                                    : AppColors.lightPrimary)
                                                .withOpacity(0.3),
                                            (isDark
                                                    ? AppColors.darkRadialGlow
                                                    : AppColors.lightPrimary)
                                                .withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.3, 0.7, 1.0],
                                        ),
                                      ),
                                    ),

                                    // Neon Ring Shadow
                                    Container(
                                      width: Get.width * 0.35,
                                      height: Get.width * 0.35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (isDark
                                                        ? AppColors
                                                              .darkRadialGlow
                                                        : AppColors
                                                              .lightPrimary)
                                                    .withOpacity(0.4),
                                            blurRadius: 30,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Main Avatar Container
                                    Container(
                                      width: Get.width * .28,
                                      height: Get.width * .28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDark
                                            ? AppColors.darkSecondaryBackground
                                            : Colors.grey[100],
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.darkPrimary
                                                    .withOpacity(0.5)
                                              : AppColors.lightPrimary
                                                    .withOpacity(0.2),
                                          width: 2.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (isDark
                                                        ? AppColors.darkPrimary
                                                        : AppColors
                                                              .lightPrimary)
                                                    .withOpacity(0.2),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Remix.user_3_line,
                                        size: Get.width * .15,
                                        color: isDark
                                            ? AppColors.darkRadialGlow
                                            : AppColors.lightPrimary,
                                      ),
                                    ),
                                  ],
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
                                        ? AppColors.darkSecondaryBackground
                                              .withOpacity(0.8)
                                        : const Color(0xFFF2F4F5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkPrimary.withOpacity(
                                              0.1,
                                            )
                                          : Colors.transparent,
                                    ),
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
                                                        : AppColors.pureWhite)
                                                  : AppColors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow:
                                                  controller.isEmailLogin.value
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .pureBlack
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
                                                          ? AppColors.pureWhite
                                                          : const Color(
                                                              0xFF6C757D,
                                                            ))
                                                    : (isDark
                                                          ? AppColors.white54
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
                                                        : AppColors.pureWhite)
                                                  : AppColors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow:
                                                  !controller.isEmailLogin.value
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .pureBlack
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
                                              "OTP Login",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color:
                                                    !controller
                                                        .isEmailLogin
                                                        .value
                                                    ? (isDark
                                                          ? AppColors.pureWhite
                                                          : const Color(
                                                              0xFF6C757D,
                                                            ))
                                                    : (isDark
                                                          ? AppColors.white54
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

                              // Form Fields with IndexedStack for stability
                              SizedBox(height: Get.height * 0.03),
                              Obx(
                                () => IndexedStack(
                                  index: controller.isEmailLogin.value ? 0 : 1,
                                  sizing: StackFit.loose,
                                  children: [
                                    // EMAIL LOGIN FORM
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.darkRadialGlow
                                                : AppColors.lightPrimary,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        TextField(
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Remix.mail_line,
                                              size: 20,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.5),
                                            ),
                                            hintText: "Enter your email",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.3),
                                            ),
                                            filled: true,
                                            fillColor: isDark
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.black.withOpacity(
                                                    0.05,
                                                  ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color:
                                                    (isDark
                                                            ? AppColors.darkText
                                                            : AppColors
                                                                  .lightText)
                                                        .withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: isDark
                                                    ? AppColors.darkRadialGlow
                                                    : AppColors.lightPrimary,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? AppColors.darkText
                                                : AppColors.lightText,
                                          ),
                                          onChanged: (val) =>
                                              controller.email.value = val,
                                        ),
                                        SizedBox(height: Get.height * 0.02),
                                        Text(
                                          "Password",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.darkRadialGlow
                                                : AppColors.lightPrimary,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        TextField(
                                          controller: passwordController,
                                          obscureText: obscurePassword,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Remix.lock_password_line,
                                              size: 20,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.5),
                                            ),
                                            hintText: "Enter your password",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.3),
                                            ),
                                            filled: true,
                                            fillColor: isDark
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.black.withOpacity(
                                                    0.05,
                                                  ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color:
                                                    (isDark
                                                            ? AppColors.darkText
                                                            : AppColors
                                                                  .lightText)
                                                        .withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: isDark
                                                    ? AppColors.darkRadialGlow
                                                    : AppColors.lightPrimary,
                                                width: 1.5,
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obscurePassword
                                                    ? Remix.eye_off_line
                                                    : Remix.eye_line,
                                                size: 20,
                                                color:
                                                    (isDark
                                                            ? AppColors.darkText
                                                            : AppColors
                                                                  .lightText)
                                                        .withOpacity(0.4),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  obscurePassword =
                                                      !obscurePassword;
                                                });
                                              },
                                            ),
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? AppColors.darkText
                                                : AppColors.lightText,
                                          ),
                                          onChanged: (val) =>
                                              controller.password.value = val,
                                        ),
                                      ],
                                    ),
                                    // MOBILE LOGIN FORM
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email for OTP",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.darkRadialGlow
                                                : AppColors.lightPrimary,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        TextField(
                                          controller:
                                              mobileController, // keeping controller for simplicity but usage is email
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Remix.mail_line,
                                              size: 20,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.5),
                                            ),
                                            hintText:
                                                "Enter your email for OTP",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  (isDark
                                                          ? AppColors.darkText
                                                          : AppColors.lightText)
                                                      .withOpacity(0.3),
                                            ),
                                            filled: true,
                                            fillColor: isDark
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.black.withOpacity(
                                                    0.05,
                                                  ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color:
                                                    (isDark
                                                            ? AppColors.darkText
                                                            : AppColors
                                                                  .lightText)
                                                        .withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: isDark
                                                    ? AppColors.darkRadialGlow
                                                    : AppColors.lightPrimary,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? AppColors.darkText
                                                : AppColors.lightText,
                                          ),
                                          onChanged: (val) {
                                            controller.email.value = val;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: Get.height * 0.02),

                              SizedBox(height: Get.height * 0.05),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: Get.height * 0.07,
                                child: Obx(
                                  () => ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          shadowColor:
                                              (isDark
                                                      ? AppColors.darkRadialGlow
                                                      : AppColors.lightPrimary)
                                                  .withOpacity(0.4),
                                          elevation: 8,
                                        ).copyWith(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Colors.transparent,
                                              ),
                                        ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () {
                                            controller.login();
                                          },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isDark
                                              ? [
                                                  AppColors.darkRadialGlow,
                                                  AppColors.glowPurple,
                                                ]
                                              : [
                                                  AppColors.lightPrimary,
                                                  AppColors.lightPrimary
                                                      .withOpacity(0.8),
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: controller.isLoading.value
                                            ? const _DotsLoading()
                                            : Text(
                                                "Log In",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: Get.height * 0.03),

                              // OR separator
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color:
                                          (isDark
                                                  ? AppColors.darkText
                                                  : AppColors.lightText)
                                              .withOpacity(0.1),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'OR',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color:
                                            (isDark
                                                    ? AppColors.darkText
                                                    : AppColors.lightText)
                                                .withOpacity(0.4),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color:
                                          (isDark
                                                  ? AppColors.darkText
                                                  : AppColors.lightText)
                                              .withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: Get.height * 0.02),

                              // Create Account Button
                              Center(
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.registerView),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "New to SecureMe? ",
                                      style: GoogleFonts.poppins(
                                        color:
                                            (isDark
                                                    ? AppColors.darkText
                                                    : AppColors.lightText)
                                                .withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Create Account",
                                          style: GoogleFonts.poppins(
                                            color: isDark
                                                ? AppColors.darkRadialGlow
                                                : AppColors.lightPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
                ],
              );
            },
          ),
        ),
      );
    });
  }
}

// Animated 3-dots loading indicator for buttons
class _DotsLoading extends StatefulWidget {
  const _DotsLoading();

  @override
  State<_DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<_DotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final t = ((_ctrl.value + i / 3) % 1.0);
            final scale = 0.6 + 0.4 * (1 - (2 * t - 1).abs());
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

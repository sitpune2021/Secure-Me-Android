import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/theme/app_theme.dart';

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

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = AppTheme.getThemeForRole(controller.selectedRole.value.name, isDark: themeController.isDarkMode.value).primaryColor;
      final isDark = themeController.isDarkMode.value;
      final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
      final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              stretch: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Atmospheric glow
                    Positioned(
                      top: -100,
                      right: -50,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: roleColor.withValues(alpha: 0.15),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: const Duration(seconds: 5),
                          ),
                    ),
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: roleColor.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Remix.shield_keyhole_fill,
                          size: 44,
                          color: roleColor,
                        ),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(
                            duration: const Duration(seconds: 3),
                            color: Colors.white24,
                          ),
                    ),
                  ],
                ),
                titlePadding: const EdgeInsets.only(bottom: 16),
                centerTitle: true,
                title: Text(
                  'SECURE ME',
                  style: GoogleFonts.outfit(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  Text(
                    'WELCOME BACK',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: roleColor,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your secure space',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: subTextColor,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
                  const SizedBox(height: 40),

                  // Role Selection Header
                  Text(
                    'I AM A:',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: subTextColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Optimized Role Grid
                  _buildRoleSelector(roleColor, isDark),
                  
                  const SizedBox(height: 32),

                  // Method Switcher
                  Container(
                    height: 54,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildToggleBtn(
                            "Email Login",
                            controller.isEmailLogin.value,
                            roleColor,
                            () => controller.isEmailLogin.value = true,
                          ),
                        ),
                        Expanded(
                          child: _buildToggleBtn(
                            "OTP Login",
                            !controller.isEmailLogin.value,
                            roleColor,
                            () => controller.isEmailLogin.value = false,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Input Fields - Replacing IndexedStack with simple conditional build to avoid hit test errors
                  if (controller.isEmailLogin.value) ...[
                    _buildField(
                      controller: emailController,
                      hint: "Email Address",
                      icon: Remix.mail_fill,
                      color: roleColor,
                      isDark: isDark,
                      onChanged: (v) => controller.email.value = v,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: passwordController,
                      hint: "Password",
                      icon: Remix.lock_2_fill,
                      color: roleColor,
                      isDark: isDark,
                      obscure: obscurePassword,
                      onChanged: (v) => controller.password.value = v,
                      suffix: IconButton(
                        icon: Icon(
                          obscurePassword ? Remix.eye_off_line : Remix.eye_line,
                          color: subTextColor.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.outfit(
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildField(
                      controller: emailController,
                      hint: "Email ID for OTP",
                      icon: Remix.mail_send_fill,
                      color: roleColor,
                      isDark: isDark,
                      onChanged: (v) => controller.email.value = v,
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Tactical Login Button
                  ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roleColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      shadowColor: roleColor.withValues(alpha: 0.4),
                    ),
                    child: controller.isLoading.value 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.isEmailLogin.value ? 'INITIATE LOGIN' : 'RECOVERY ACCESS',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Remix.arrow_right_line, size: 20),
                          ],
                        ),
                  ),

                  const SizedBox(height: 48),

                  // Divider with premium OR
                  Row(
                    children: [
                      Expanded(child: Divider(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'CONTINUE WITH',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: subTextColor.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05))),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Social / Register Link
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.registerView),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: roleColor.withValues(alpha: 0.3)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "NEW MEMBER? ",
                            style: GoogleFonts.outfit(color: subTextColor, fontSize: 13, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: "CREATE ACCOUNT",
                                style: GoogleFonts.outfit(
                                  color: roleColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRoleSelector(Color roleColor, bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: UserRole.values.map((role) {
        final isSelected = controller.selectedRole.value == role;
        final thisColor = AppTheme.getThemeForRole(role.name, isDark: isDark).primaryColor;
        
        return GestureDetector(
          onTap: () => controller.selectedRole.value = role,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? thisColor.withValues(alpha: 0.15) : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? thisColor : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Remix.checkbox_circle_fill : Remix.checkbox_blank_circle_line,
                  size: 16,
                  color: isSelected ? thisColor : (isDark ? Colors.white24 : Colors.black26),
                ),
                const SizedBox(width: 8),
                Text(
                  role.name,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? thisColor : (isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToggleBtn(String label, bool active, Color color, VoidCallback t) {
    return GestureDetector(
      onTap: t,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            color: active ? Colors.white : (themeController.isDarkMode.value ? Colors.white54 : Colors.black54),
            fontSize: 11,
            fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
    required bool isDark,
    bool obscure = false,
    Widget? suffix,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3), fontWeight: FontWeight.w500),
              prefixIcon: Icon(icon, color: color.withValues(alpha: 0.6), size: 22),
              suffixIcon: suffix,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: color, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}

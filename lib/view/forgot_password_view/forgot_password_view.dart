import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/view/common/tactical_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final AuthController _authController = Get.find<AuthController>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = _themeController.isDarkMode.value;
        final roleColor = AppTheme.primaryRed; // Using primary red for tactical recovery
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              stretch: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Remix.arrow_left_line, color: textColor),
                  onPressed: () => Get.back(),
                ),
              ),
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
                          color: roleColor.withValues(alpha: 0.1),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: const Duration(seconds: 5),
                          ),
                    ),
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: roleColor.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Remix.lock_password_fill,
                          size: 48,
                          color: roleColor,
                        ),
                      ),
                    ).animate().scale(duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack).fade(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  Text(
                    'RECOVER ACCOUNT',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: -0.1),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Enter your tactical credentials to receive secure recovery instructions.',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: subTextColor,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
                  
                  const SizedBox(height: 48),
                  
                  // Email Input
                  _buildInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    icon: Remix.mail_send_fill,
                    isDark: isDark,
                    color: roleColor,
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                  
                  const SizedBox(height: 48),
                  
                  TacticalButton(
                    label: 'SEND RESET LINK',
                    onTap: _handleReset,
                    icon: Remix.send_plane_2_fill,
                    isLoading: _authController.isLoading.value,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Back to Login Center
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: roleColor.withValues(alpha: 0.3)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "REMEMBERED? ",
                            style: GoogleFonts.outfit(color: subTextColor, fontSize: 13, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: "LOG IN",
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
        );
      }),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: TextField(
            controller: controller,
            cursorColor: color,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : color.withValues(alpha: 0.9),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(
                color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: color.withValues(alpha: 0.5), size: 20),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: color.withValues(alpha: 0.8), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  void _handleReset() {
    final email = _emailController.text.trim();
    _authController.forgotPassword(email);
  }
}

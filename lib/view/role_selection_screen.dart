import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:secure_me/app/theme/app_theme.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/view/common/tactical_button.dart';

enum AppUserType { securePerson, protector }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final ThemeController _themeController = Get.find<ThemeController>();
  final LoginController _loginController = Get.put(LoginController());

  AppUserType _selected = AppUserType.securePerson;

  // Only used for theme color on the login screen.
  // The real role still comes from the API after login.
  UserRole _mapRole(AppUserType type) =>
      type == AppUserType.securePerson ? UserRole.manager : UserRole.police;

  void _onContinue() {
    _loginController.selectedRole.value = _mapRole(_selected);
    Get.toNamed(AppRoutes.loginView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = _themeController.isDarkMode.value;
        final roleColor = AppTheme.getThemeForRole(
          _mapRole(_selected).name,
          isDark: isDark,
        ).primaryColor;
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child:
                      Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: roleColor.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .animate()
                          .scale(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutBack,
                          )
                          .fade(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'SECURE ME',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: textColor,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                ),
                const SizedBox(height: 40),
                Text(
                      'CHOOSE YOUR ROLE',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: -1,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideX(begin: -0.1),
                const SizedBox(height: 4),
                Text(
                  'Select how you want to use the safety network',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: subTextColor,
                    height: 1.4,
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                const SizedBox(height: 32),
                _buildRoleCard(
                  type: AppUserType.securePerson,
                  title: 'SECURE PERSON',
                  subtitle: 'I want to stay safe and alert my protectors',
                  icon: Remix.user_heart_fill,
                  color: roleColor,
                  isDark: isDark,
                ).animate().fadeIn(delay: const Duration(milliseconds: 450)),
                const SizedBox(height: 16),
                _buildRoleCard(
                  type: AppUserType.protector,
                  title: 'PROTECTOR',
                  subtitle: 'I want to respond and protect others',
                  icon: Remix.shield_star_fill,
                  color: roleColor,
                  isDark: isDark,
                ).animate().fadeIn(delay: const Duration(milliseconds: 550)),
                const Spacer(),
                TacticalButton(
                  label: 'CONTINUE',
                  onTap: _onContinue,
                  icon: Remix.arrow_right_line,
                  isLoading: false,
                  color: roleColor,
                ).animate().fadeIn(delay: const Duration(milliseconds: 650)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRoleCard({
    required AppUserType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    final active = _selected == type;
    final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);

    return GestureDetector(
      onTap: () => setState(() => _selected = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.12)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? color : (isDark ? Colors.white10 : Colors.black12),
            width: active ? 2 : 1,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: active ? color : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: active ? Colors.white : color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              active
                  ? Remix.checkbox_circle_fill
                  : Remix.checkbox_blank_circle_line,
              color: active
                  ? color
                  : (isDark ? Colors.white24 : Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}

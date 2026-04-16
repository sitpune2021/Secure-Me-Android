import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/view/common/tactical_button.dart';
import 'package:flutter/material.dart'; // Added this import as it was missing for StatefulWidget, State, Scaffold, etc.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  final ThemeController _themeController = Get.find<ThemeController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = _themeController.isDarkMode.value;
        final roleColor = AppTheme.getThemeForRole(_loginController.selectedRole.value.name, isDark: isDark).primaryColor;
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);

        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white : Colors.white,
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
                          ).animate().scale(duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack).fade(),
                          const SizedBox(height: 16),
                          Text(
                            'SECURE ME',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: textColor,
                            ),
                          ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  Text(
                    'WELCOME BACK',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideX(begin: -0.1),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    'Access your tactical safety network',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: subTextColor,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                  
                  const SizedBox(height: 24),
                  
                  // Role Selection Label
                  Text(
                    'LOGGING IN AS',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: subTextColor.withValues(alpha: 0.5),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Roles Grid
                  _buildRoleSelector(roleColor, isDark),
                  
                  const SizedBox(height: 20),
                  
                  // Input Fields
                  _buildInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    icon: Remix.mail_fill,
                    isDark: isDark,
                    color: roleColor,
                    onChanged: (val) => _loginController.email.value = val,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildInputField(
                    label: 'PASSWORD',
                    hintText: '••••••••',
                    controller: _passwordController,
                    icon: Remix.lock_fill,
                    isPassword: true,
                    isDark: isDark,
                    color: roleColor,
                    showForgotPassword: true,
                    onChanged: (val) => _loginController.password.value = val,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Log In Button
                  TacticalButton(
                    label: 'INITIATE LOGIN',
                    onTap: _handleLogin,
                    icon: Remix.arrow_right_line,
                    isLoading: _loginController.isLoading.value,
                    color: roleColor,
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
                  
                  const SizedBox(height: 24),
                  
                  // Footer
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
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomBadge(Remix.shield_check_fill, 'END-TO-END\nENCRYPTED', isDark),
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black12, shape: BoxShape.circle)),
                      _buildBottomBadge(Remix.error_warning_fill, 'TACTICAL\nPROTECTION', isDark),
                    ],
                  ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
                  
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRoleSelector(Color roleColor, bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: UserRole.values.map((role) {
        final isSelected = _loginController.selectedRole.value == role;
        final thisColor = AppTheme.getThemeForRole(role.name, isDark: isDark).primaryColor;
        
        String getRoleDisplayName(UserRole role) {
          switch (role) {
            case UserRole.Police:
              return "Police";
            case UserRole.Manager:
              return "Manager";
            case UserRole.Gym_Person:
              return "Gym";
          }
        }

        IconData getRoleIcon(UserRole role) {
          switch (role) {
            case UserRole.Police:
              return Remix.shield_star_fill;
            case UserRole.Manager:
              return Remix.briefcase_4_fill;
            case UserRole.Gym_Person:
              return Remix.user_smile_fill;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(right: 0),
          child: GestureDetector(
            onTap: () => _loginController.selectedRole.value = role,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? thisColor.withValues(alpha: 0.12) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? thisColor : (isDark ? Colors.white10 : Colors.black12),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getRoleIcon(role), 
                    size: 16, 
                    color: isSelected ? thisColor : (isDark ? Colors.white38 : Colors.black45)
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getRoleDisplayName(role),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                      color: isSelected ? thisColor : (isDark ? Colors.white38 : Colors.black45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBadge(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: isDark ? Colors.white24 : Colors.black26, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: isDark ? Colors.white24 : Colors.black26,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    required Color color,
    bool isPassword = false,
    bool showForgotPassword = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            if (showForgotPassword)
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                child: Text(
                  'FORGOT PASSWORD?',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
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
            onChanged: onChanged,
            obscureText: isPassword && _obscurePassword,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(
                color: isDark ? Colors.white24 : Colors.black26,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: color.withValues(alpha: 0.6), size: 20),
              suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(
                      _obscurePassword ? Remix.eye_off_fill : Remix.eye_fill,
                      color: isDark ? Colors.white24 : Colors.black26,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: color, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    _loginController.login();
  }
}

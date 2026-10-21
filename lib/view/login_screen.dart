
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/app/theme/app_theme.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/view/common/tactical_button.dart';
import 'package:flutter/material.dart';

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

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleFieldSubmit(VoidCallback action) {
    action();
  }

  // ─── Role helpers ─────────────────────────────────────────────────────────
  // Login screen color stays the same for every role (original default theme).
  Color _fixedColor(bool isDark) => AppTheme.getThemeForRole(
    UserRole.manager.name,
    isDark: isDark,
  ).primaryColor;

  String _roleLabel(UserRole role) =>
      role == UserRole.police ? 'PROTECTOR' : 'SECURE PERSON';

  IconData _roleIcon(UserRole role) =>
      role == UserRole.police ? Remix.shield_star_fill : Remix.user_heart_fill;

  void _showSwitchRoleSheet(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);

    Widget option(UserRole role, String subtitle) {
      return Obx(() {
        final active = _loginController.selectedRole.value == role;
        final color = _fixedColor(isDark);
        return GestureDetector(
          onTap: () {
            _loginController.selectedRole.value = role;
            Get.back();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active
                  ? color.withValues(alpha: 0.12)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: active
                    ? color
                    : (isDark ? Colors.white10 : Colors.black12),
                width: active ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: active ? color : color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _roleIcon(role),
                    color: active ? Colors.white : color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _roleLabel(role),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black54,
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
      });
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'SWITCH ROLE',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              option(UserRole.manager, 'Stay safe and alert your protectors'),
              option(UserRole.police, 'Respond and protect others'),
            ],
          ),
        ),
      ),
    );
  }
  // ──────────────────────────────────────────────────────────────────────────

  // ─── Toggle button (same style as LoginView) ──────────────────────────────
  Widget _buildToggleBtn({
    required String label,
    required bool active,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            color: active
                ? Colors.white
                : (isDark ? Colors.white54 : Colors.black54),
            fontSize: 11,
            fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = _themeController.isDarkMode.value;
        final selectedRole = _loginController.selectedRole.value;
        final roleColor = _fixedColor(isDark);
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);
        final isEmailLogin = _loginController.isEmailLogin.value;

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
                    Positioned(
                      top: -100,
                      right: -50,
                      child:
                          Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: roleColor.withValues(alpha: 0.15),
                                ),
                              )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.2, 1.2),
                                duration: const Duration(seconds: 5),
                              ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25),
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
                          const SizedBox(height: 16),
                          Text(
                            'SECURE ME',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: textColor,
                            ),
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 200),
                          ),
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

                  // ─── WELCOME BACK + selected role chip (switch role) ─────
                  Row(
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'WELCOME BACK',
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showSwitchRoleSheet(isDark),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: roleColor.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _roleIcon(selectedRole),
                                    color: roleColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _roleLabel(selectedRole),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                      color: roleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Remix.arrow_left_right_line,
                                    color: roleColor,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 300))
                      .slideX(begin: -0.1),

                  // ──────────────────────────────────────────────────────────
                  const SizedBox(height: 4),

                  Text(
                    'Access your tactical safety network',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: subTextColor,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),

                  const SizedBox(height: 36),

                  // Email / OTP toggle
                  Container(
                    height: 54,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildToggleBtn(
                            label: 'Email Login',
                            active: isEmailLogin,
                            color: roleColor,
                            isDark: isDark,
                            onTap: () {
                              _loginController.isEmailLogin.value = true;
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _emailFocus.requestFocus(),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildToggleBtn(
                            label: 'OTP Login',
                            active: !isEmailLogin,
                            color: roleColor,
                            isDark: isDark,
                            onTap: () {
                              _loginController.isEmailLogin.value = false;
                              _emailController.clear();
                              _loginController.email.value = '';
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _emailFocus.requestFocus(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 450)),

                  const SizedBox(height: 24),

                  // Email field (shared by both modes)
                  _buildInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: isEmailLogin
                        ? 'name@example.com'
                        : 'Enter email to receive OTP',
                    controller: _emailController,
                    icon: isEmailLogin ? Remix.mail_fill : Remix.mail_send_fill,
                    isDark: isDark,
                    color: roleColor,
                    focusNode: _emailFocus,
                    textInputAction: isEmailLogin
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onFieldSubmit: isEmailLogin
                        ? () => _handleFieldSubmit(
                            () => FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocus),
                          )
                        : () => _handleFieldSubmit(_handleLogin),
                    onChanged: (val) => _loginController.email.value = val,
                  ),

                  // Password field: only shown in email-login mode
                  if (isEmailLogin) ...[
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
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmit: () => _handleFieldSubmit(() {
                        _passwordFocus.unfocus();
                        _handleLogin();
                      }),
                      onChanged: (val) => _loginController.password.value = val,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Login button — label changes per mode
                  TacticalButton(
                    label: isEmailLogin ? 'INITIATE LOGIN' : 'SEND OTP',
                    onTap: _handleLogin,
                    icon: isEmailLogin
                        ? Remix.arrow_right_line
                        : Remix.mail_send_line,
                    isLoading: _loginController.isLoading.value,
                    color: roleColor,
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)),

                  const SizedBox(height: 24),

                  // Footer
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.registerView),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: roleColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "NEW MEMBER? ",
                            style: GoogleFonts.outfit(
                              color: subTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
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
                      _buildBottomBadge(
                        Remix.shield_check_fill,
                        'END-TO-END\nENCRYPTED',
                        isDark,
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black12,
                          shape: BoxShape.circle,
                        ),
                      ),
                      _buildBottomBadge(
                        Remix.error_warning_fill,
                        'TACTICAL\nPROTECTION',
                        isDark,
                      ),
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
    FocusNode? focusNode,
    TextInputAction textInputAction = TextInputAction.next,
    VoidCallback? onFieldSubmit,
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
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onEditingComplete: () => onFieldSubmit?.call(),
            onSubmitted: (_) => onFieldSubmit?.call(),
            onChanged: onChanged,
            obscureText: isPassword && _obscurePassword,
            cursorColor: color,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : color.withValues(alpha: 0.9),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.2),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                icon,
                color: color.withValues(alpha: 0.5),
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Remix.eye_off_fill : Remix.eye_fill,
                        color: isDark ? Colors.white24 : Colors.black26,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: color.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    // Single entry-point: controller routes to _loginWithEmail or
    // _loginWithMobile based on isEmailLogin.value
    _loginController.login();
  }
}

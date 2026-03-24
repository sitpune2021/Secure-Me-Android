import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/theme.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = AppTheme.getThemeForRole(controller.selectedRole.value.name).primaryColor;

      return Scaffold(
        backgroundColor: const Color(0XFF0A0A0F),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Login Account',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Logo/Avatar Section
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: roleColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    size: 50,
                    color: roleColor,
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: const Duration(seconds: 3), color: Colors.white10),
              ),
              
              const SizedBox(height: 32),

              // Role Selection (Same as Register)
              Text(
                'I am a:',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: UserRole.values.map((role) {
                  final isSelected = controller.selectedRole.value == role;
                  final thisRoleColor = AppTheme.getThemeForRole(role.name).primaryColor;
                  
                  return GestureDetector(
                    onTap: () => controller.selectedRole.value = role,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? thisRoleColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? thisRoleColor : Colors.white12,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        role.name[0].toUpperCase() + role.name.substring(1),
                        style: TextStyle(
                          color: isSelected ? thisRoleColor : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Enhanced Login Method Toggle
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildLoginToggleItem(
                        "Email Login",
                        controller.isEmailLogin.value,
                        roleColor,
                        () => controller.isEmailLogin.value = true,
                      ),
                    ),
                    Expanded(
                      child: _buildLoginToggleItem(
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

              // Input Fields (Styled like Register)
              Obx(() => IndexedStack(
                index: controller.isEmailLogin.value ? 0 : 1,
                sizing: StackFit.loose,
                children: [
                  // EMAIL LOGIN
                  Column(
                    children: [
                      _buildLoginField(
                        controller: emailController,
                        hintText: "Email Address",
                        icon: Icons.email_outlined,
                        roleColor: roleColor,
                        onChanged: (val) => controller.email.value = val,
                      ),
                      const SizedBox(height: 16),
                      _buildLoginField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: Icons.lock_outline,
                        roleColor: roleColor,
                        obscureText: obscurePassword,
                        onChanged: (val) => controller.password.value = val,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                      ),
                    ],
                  ),
                  // OTP LOGIN
                  _buildLoginField(
                    controller: mobileController,
                    hintText: "Email for OTP",
                    icon: Icons.mail_outline,
                    roleColor: roleColor,
                    onChanged: (val) => controller.email.value = val,
                  ),
                ],
              )),

              const SizedBox(height: 48),

              // Login Button (ElevatedButton same as Register)
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.login(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: roleColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 8,
                  shadowColor: roleColor.withValues(alpha: 0.5),
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      controller.isEmailLogin.value ? 'Login' : 'Send OTP',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
              )),

              const SizedBox(height: 32),

              // OR separator
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                ],
              ),

              const SizedBox(height: 32),

              // Create Account Link
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.registerView),
                  child: RichText(
                    text: TextSpan(
                      text: "New to SecureMe? ",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Create Account",
                          style: GoogleFonts.poppins(
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoginToggleItem(String label, bool isSelected, Color roleColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? roleColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [
            BoxShadow(
              color: roleColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.white38,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color roleColor,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        prefixIcon: Icon(icon, color: roleColor.withValues(alpha: 0.7)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: roleColor, width: 1.5),
        ),
      ),
    );
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
      builder: (_, _) {
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

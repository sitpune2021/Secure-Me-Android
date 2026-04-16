import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/register_controller/register_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/location_controller.dart';
import 'package:secure_me/view/common/tactical_button.dart';
import 'package:secure_me/view/common/app_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _registerController = Get.put(RegisterController());
  final AuthController _authController = Get.find<AuthController>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final LocationController _locationController = Get.find<LocationController>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = _themeController.isDarkMode.value;
        final roleColor = AppTheme.getThemeForRole(_authController.selectedRole.value.name, isDark: isDark).primaryColor;
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7D7D7D);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
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
                      left: -50,
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
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: roleColor.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ).animate().scale(duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack),
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
                    'CREATE ACCOUNT',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideX(begin: -0.1),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    'Join the tactical safety network',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: subTextColor,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                  
                  const SizedBox(height: 16),
                  
                  // Profile Image Picker
                  Center(
                    child: GestureDetector(
                      onTap: () => _showImagePicker(context, roleColor, isDark),
                      child: Stack(
                        children: [
                          Obx(() => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              image: _registerController.selectedImage.value != null
                                ? DecorationImage(
                                    image: FileImage(_registerController.selectedImage.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            ),
                            child: _registerController.selectedImage.value == null
                              ? Icon(
                                  Remix.user_add_fill,
                                  size: 40,
                                  color: roleColor.withValues(alpha: 0.5),
                                )
                              : null,
                          )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: roleColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Remix.camera_fill,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 500)).scale(),
                  ),

                  const SizedBox(height: 16),
                  
                  // Role Selection Label
                  Text(
                    'SELECT YOUR ROLE',
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
                  
                  const SizedBox(height: 16),
                  
                  // Input Fields
                  _buildInputField(
                    label: 'FULL NAME',
                    hintText: 'Johnathan Doe',
                    controller: _nameController,
                    icon: Remix.user_3_fill,
                    isDark: isDark,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    icon: Remix.mail_fill,
                    isDark: isDark,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInputField(
                    label: 'PHONE NUMBER',
                    hintText: '9823306798',
                    controller: _phoneController,
                    icon: Remix.phone_fill,
                    isDark: isDark,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInputField(
                    label: 'PASSWORD',
                    hintText: '••••••••',
                    controller: _passwordController,
                    icon: Remix.lock_fill,
                    isPassword: true,
                    isPassObscured: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    isDark: isDark,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInputField(
                    label: 'CONFIRM PASSWORD',
                    hintText: '••••••••',
                    controller: _confirmPasswordController,
                    icon: Remix.shield_check_fill,
                    isPassword: true,
                    isPassObscured: _obscureConfirmPassword,
                    onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    isDark: isDark,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Create Account Button
                  TacticalButton(
                    label: 'DEPLOY ACCOUNT',
                    onTap: _handleRegister,
                    icon: Remix.arrow_right_line,
                    isLoading: _registerController.isLoading.value,
                    color: roleColor,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Footer
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
                            text: "ALREADY A MEMBER? ",
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
        final isSelected = _authController.selectedRole.value == role;
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

        return GestureDetector(
          onTap: () => _authController.setSelectedRole(role),
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
        );
      }).toList(),
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
    bool isPassObscured = false,
    VoidCallback? onToggleObscure,
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
            obscureText: isPassword && isPassObscured,
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
                      isPassObscured ? Remix.eye_off_fill : Remix.eye_fill,
                      color: isDark ? Colors.white24 : Colors.black26,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
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

  void _handleRegister() {
    final pos = _locationController.currentPosition.value;
    
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      AppSnackbar.show(
        title: "Password Mismatch",
        message: "Passwords do not match. Please try again.",
        isError: true,
      );
      return;
    }
    
    _registerController.registerUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      role: _authController.selectedRole.value.name,
      latitude: pos?.latitude,
      longitude: pos?.longitude,
    );
  }

  void _showImagePicker(BuildContext context, Color roleColor, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SELECT PROFILE PHOTO",
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildPickerOption(
                  icon: Remix.camera_fill,
                  label: "CAMERA",
                  onTap: () {
                    Get.back();
                    _registerController.pickImage(ImageSource.camera);
                  },
                  roleColor: roleColor,
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildPickerOption(
                  icon: Remix.image_fill,
                  label: "GALLERY",
                  onTap: () {
                    Get.back();
                    _registerController.pickImage(ImageSource.gallery);
                  },
                  roleColor: roleColor,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color roleColor,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: roleColor, size: 28),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

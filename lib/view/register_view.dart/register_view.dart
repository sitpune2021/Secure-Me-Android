import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_me/controller/register_controller/register_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final ThemeController themeController = Get.find<ThemeController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = "User"; // Default role
  final List<String> _roles = ["User", "Gym_Person", "Guardian", "Police"];
  final RegisterController registerController = Get.put(RegisterController());

  // Password visibility toggle
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            ),
          ),
          title: Text(
            "Create Account",
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.02),

                // Profile Avatar with premium glow
                GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Multiple Radial Glow Layers for a richer effect
                      Container(
                        width: Get.width * 0.52,
                        height: Get.width * 0.52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              (isDark
                                      ? AppColors.darkRadialGlow
                                      : AppColors.lightPrimary)
                                  .withOpacity(0.35),
                              (isDark
                                      ? AppColors.darkRadialGlow
                                      : AppColors.lightPrimary)
                                  .withOpacity(0.12),
                              Colors.transparent,
                            ],
                            stops: const [0.3, 0.7, 1.0],
                          ),
                        ),
                      ),

                      // Secondary concentrated glow
                      Container(
                        width: Get.width * 0.42,
                        height: Get.width * 0.42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isDark
                                          ? AppColors.darkRadialGlow
                                          : AppColors.lightPrimary)
                                      .withOpacity(0.5),
                              blurRadius: 35,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // Outer Border/Glow Ring
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkPrimary.withOpacity(0.6)
                                : AppColors.lightPrimary.withOpacity(0.3),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary)
                                      .withOpacity(0.25),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Obx(
                          () => CircleAvatar(
                            radius: Get.width * 0.18,
                            backgroundColor: isDark
                                ? AppColors.darkSecondaryBackground
                                : Colors.grey[100],
                            backgroundImage:
                                registerController.selectedImage.value != null
                                ? FileImage(
                                    registerController.selectedImage.value!,
                                  )
                                : null,
                            child:
                                registerController.selectedImage.value == null
                                ? Icon(
                                    Remix.user_3_line,
                                    size: Get.width * 0.15,
                                    color: isDark
                                        ? AppColors.darkText.withOpacity(0.4)
                                        : AppColors.lightText.withOpacity(0.4),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      // Camera Icon Badge with more pop
                      Positioned(
                        bottom: 6,
                        right: Get.width * 0.03,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      AppColors.darkRadialGlow,
                                      AppColors.darkPrimary,
                                    ]
                                  : [
                                      AppColors.lightPrimary,
                                      AppColors.lightSecondary,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBackground
                                  : Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isDark
                                            ? AppColors.darkRadialGlow
                                            : AppColors.lightPrimary)
                                        .withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                _buildProfileField("Name", _nameController, "Abc", isDark, (
                  value,
                ) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                }),
                SizedBox(height: Get.height * 0.03),

                // Role Selection (Moved Higher for visibility)
                _buildRoleDropdown(theme, isDark),
                SizedBox(height: Get.height * 0.03),

                // Phone Field
                _buildProfileField(
                  "Phone",
                  _phoneController,
                  "1111111111",
                  isDark,
                  (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Enter a valid 10-digit phone number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),

                _buildProfileField(
                  "Email",
                  _emailController,
                  "abc@email.com",
                  isDark,
                  (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                    ).hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Get.height * 0.03),

                // Password Field
                _buildProfileField(
                  "Password",
                  _passwordController,
                  "********",
                  isDark,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Remix.eye_off_line : Remix.eye_line,
                      color: (isDark ? AppColors.darkText : AppColors.lightText)
                          .withOpacity(0.6),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.03),

                SizedBox(height: Get.height * 0.03),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: Get.height * 0.022,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: isDark
                            ? AppColors.darkRadialGlow
                            : AppColors.lightPrimary,
                        elevation: isDark ? 8 : 4,
                        shadowColor:
                            (isDark
                                    ? AppColors.darkRadialGlow
                                    : AppColors.lightPrimary)
                                .withOpacity(0.5),
                      ),
                      onPressed: registerController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                registerController.registerUser(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  role: _selectedRole,
                                );
                              }
                            },
                      child: registerController.isLoading.value
                          ? const _DotsLoading()
                          : Text(
                              "Create Account",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.04),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(
                        color: isDark
                            ? AppColors.darkText.withOpacity(0.7)
                            : AppColors.lightText.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          color: isDark
                              ? AppColors.darkRadialGlow
                              : AppColors.lightPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.1), // Extra space for keyboard
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    String hint,
    bool isDark,
    String? Function(String?) validator, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isDark
                ? AppColors.darkRadialGlow.withOpacity(0.9)
                : AppColors.lightPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: isDark
                  ? AppColors.darkHint.withOpacity(0.7)
                  : AppColors.lightHint.withOpacity(0.7),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
            suffixIcon: suffixIcon,
          ),
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          height: 1,
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ],
    );
  }

  Widget _buildRoleDropdown(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I am a...",
          style: GoogleFonts.poppins(
            color: theme.colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _roles.map((role) {
            final isSelected = _selectedRole == role;
            final label = role.replaceAll('_', ' ');
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRole = role;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                              ? AppColors.darkRadialGlow
                              : AppColors.lightPrimary)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.1)),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                    .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black).withValues(
                              alpha: 0.5,
                            ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode.value;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSearchBg : AppColors.pureWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Select image from",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    registerController.pickImage(ImageSource.camera);
                  },
                  isDark: isDark,
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    registerController.pickImage(ImageSource.gallery);
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkPrimary.withOpacity(0.2)
                  : AppColors.lightPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isDark ? AppColors.darkRadialGlow : AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ],
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
      builder: (_, __) => Row(
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
      ),
    );
  }
}

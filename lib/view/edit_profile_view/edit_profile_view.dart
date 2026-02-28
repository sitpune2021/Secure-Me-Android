import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _profileImage;
  File? _imageFile;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    log('🔍 EditProfileView: Loading user data...', name: 'EditProfileView');
    final name = await PreferenceHelper.getUserName();
    final email = await PreferenceHelper.getUserEmail();
    final phone = await PreferenceHelper.getUserPhone();
    final profileImage = await PreferenceHelper.getUserProfileImage();
    setState(() {
      _profileImage = profileImage;
      if (name != null && name.isNotEmpty) _nameController.text = name;
      if (email != null && email.isNotEmpty) _emailController.text = email;
      if (phone != null && phone.isNotEmpty) _phoneController.text = phone;
    });
  }

  Future<void> _pickImage() async {
    final isDark = _effectiveDark;

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
                  onTap: () async {
                    Get.back();
                    await _handleImagePick(ImageSource.camera);
                  },
                  isDark: isDark,
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  onTap: () async {
                    Get.back();
                    await _handleImagePick(ImageSource.gallery);
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

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        log('📸 Image selected: ${pickedFile.path}', name: 'EditProfileView');
      }
    } catch (e) {
      log('❌ Error picking image: $e', name: 'EditProfileView');
    }
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final primaryColor = AppColors.primary(isDark);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? primaryColor.withValues(alpha: 0.2)
                  : primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isDark ? AppColors.darkRadialGlow : primaryColor,
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _effectiveDark {
    final isDark = themeController.isDarkMode.value;
    final userOverride = themeController.userOverride.value;
    return userOverride
        ? isDark
        : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final effectiveDark = _effectiveDark;
      final bgColor = AppColors.background(effectiveDark);
      final cardColor = AppColors.card(effectiveDark);
      final textColor = AppColors.text(effectiveDark);
      final hintColor = AppColors.hint(effectiveDark);
      final primaryColor = AppColors.primary(effectiveDark);
      final secondaryColor = AppColors.secondary(effectiveDark);
      final dividerColor = AppColors.divider(effectiveDark);
      final borderColor = AppColors.border(effectiveDark);

      return Scaffold(
        backgroundColor: bgColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Collapsible gradient header ──────────────────────────────
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: bgColor,
              surfaceTintColor: AppColors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Premium Mesh Highlight
                    Positioned(
                      top: -40,
                      left: -20,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      right: -10,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              secondaryColor.withValues(alpha: 0.25),
                              secondaryColor.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Avatar + name at bottom
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          // Avatar with camera badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 46,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : (_profileImage != null &&
                                                      _profileImage!.isNotEmpty
                                                  ? NetworkImage(
                                                      _profileImage!.startsWith(
                                                            'http',
                                                          )
                                                          ? _profileImage!
                                                          : "${AppUrl.host}/$_profileImage",
                                                    )
                                                  : null)
                                              as ImageProvider?,
                                    child:
                                        (_profileImage == null &&
                                            _imageFile == null)
                                        ? const Icon(
                                            Icons.person_rounded,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 15,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text
                                : "Your Name",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Collapsed title
              title: Text(
                "Edit Profile",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ── Form body ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section label
                      _sectionLabel("Personal Information", hintColor),
                      const SizedBox(height: 12),

                      // ── Fields card ─────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildField(
                              label: "Full Name",
                              icon: Icons.person_outline_rounded,
                              controller: _nameController,
                              hint: "Enter your name",
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? "Name is required"
                                  : null,
                              primaryColor: primaryColor,
                              textColor: textColor,
                              hintColor: hintColor,
                              dividerColor: dividerColor,
                              effectiveDark: effectiveDark,
                              isLast: false,
                              onChanged: (_) => setState(() {}),
                            ),
                            _buildField(
                              label: "Phone Number",
                              icon: Icons.phone_outlined,
                              controller: _phoneController,
                              hint: "10-digit number",
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return "Phone required";
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(v))
                                  return "Enter valid 10-digit number";
                                return null;
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                              hintColor: hintColor,
                              dividerColor: dividerColor,
                              effectiveDark: effectiveDark,
                              isLast: false,
                            ),
                            _buildField(
                              label: "Email Address",
                              icon: Icons.email_outlined,
                              controller: _emailController,
                              hint: "abc@example.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return "Email required";
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                                ).hasMatch(v)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                              hintColor: hintColor,
                              dividerColor: dividerColor,
                              effectiveDark: effectiveDark,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── Save Button ──────────────────────────────────
                      GestureDetector(
                        onTap: _isSaving
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isSaving = true);
                                  log(
                                    '💾 Saving profile...',
                                    name: 'EditProfileView',
                                  );

                                  bool success = await profileController
                                      .updateProfile(
                                        name: _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        phone: _phoneController.text.trim(),
                                        image: _imageFile,
                                      );

                                  setState(() => _isSaving = false);

                                  if (success) {
                                    Get.snackbar(
                                      "✅ Success",
                                      "Profile updated successfully",
                                      backgroundColor: primaryColor,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 14,
                                    );
                                    Future.delayed(
                                      const Duration(milliseconds: 600),
                                      () => Get.back(),
                                    );
                                  }
                                }
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isSaving
                                  ? [hintColor, hintColor]
                                  : [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _isSaving
                                ? []
                                : [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const _DotsLoading()
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Save Changes",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: color.withValues(alpha: 0.8),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required Color primaryColor,
    required Color textColor,
    required Color hintColor,
    required Color dividerColor,
    required bool effectiveDark,
    required bool isLast,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  validator: validator,
                  onChanged: onChanged,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: hintColor.withValues(alpha: 0.7),
                    ),
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                      color: hintColor.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    floatingLabelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 76,
            endIndent: 20,
            color: dividerColor.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}

// ─── Dots Loading ─────────────────────────────────────────────────────────────
class _DotsLoading extends StatefulWidget {
  const _DotsLoading();

  @override
  State<_DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<_DotsLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
            final scale = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.5, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8 * scale,
              height: 8 * scale,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:secure_me/utils/validator.dart';
import 'package:secure_me/view/common/tactical_button.dart';
import 'package:secure_me/view/common/app_snackbar.dart';

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
    final name = await PreferenceHelper.getUserName();
    final email = await PreferenceHelper.getUserEmail();
    final phone = await PreferenceHelper.getUserPhone();
    final profileImage = await PreferenceHelper.getUserProfileImage();
    setState(() {
      _profileImage = profileImage;
      if (name != null) _nameController.text = name;
      if (email != null) _emailController.text = email;
      if (phone != null) _phoneController.text = phone;
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
              "Select profile picture",
              style: GoogleFonts.outfit(
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
                  icon: Remix.camera_3_line,
                  label: "Camera",
                  onTap: () async {
                    Get.back();
                    await _handleImagePick(ImageSource.camera);
                  },
                  isDark: isDark,
                ),
                _buildSourceOption(
                  icon: Remix.image_2_line,
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
      }
    } catch (e) {
      log('❌ Error picking image: $e');
    }
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final authController = Get.find<AuthController>();
    final role = authController.user.value?.roleString ?? 
                 profileController.userData['user_role'] ?? 'user';
    final primaryColor = AppTheme.getThemeForRole(role, isDark: isDark).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ],
      ),
    );
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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final dark = _effectiveDark;
        final authController = Get.find<AuthController>();
        final role = authController.user.value?.roleString ?? 
                     profileController.userData['user_role'] ?? 'user';
        final themeData = AppTheme.getThemeForRole(role, isDark: dark);
        final primary = themeData.primaryColor;
        
        final bg = AppColors.background(dark);
        final card = AppColors.card(dark);
        final txt = AppColors.text(dark);
        final subTxt = AppColors.hint(dark);
        final divider = AppColors.divider(dark);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              backgroundColor: bg,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Remix.arrow_left_line, color: txt),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: Text(
                "Edit Profile",
                style: GoogleFonts.outfit(
                  color: txt,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, primary.withValues(alpha: 0.85)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Hero(
                                tag: 'profile_image',
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white10,
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : (_profileImage != null ? NetworkImage(AppUrl.buildImageUrl(_profileImage!)) : null),
                                    child: (_profileImage == null && _imageFile == null)
                                        ? const Icon(Remix.user_3_line, size: 50, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Remix.camera_switch_line, size: 18, color: primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader("BASIC INFORMATION", primary),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: divider.withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          children: [
                            _buildModernField(
                              label: "Full Name",
                              icon: Remix.user_line,
                              controller: _nameController,
                              hint: "Enter your full name",
                              validator: Validator.validateName,
                              primary: primary,
                              txt: txt,
                              subTxt: subTxt,
                              divider: divider,
                            ),
                            _buildModernField(
                              label: "Mobile Number",
                              icon: Remix.smartphone_line,
                              controller: _phoneController,
                              hint: "10-digit mobile number",
                              keyboardType: TextInputType.phone,
                              validator: Validator.validatePhone,
                              primary: primary,
                              txt: txt,
                              subTxt: subTxt,
                              divider: divider,
                            ),
                            _buildModernField(
                              label: "Email Address",
                              icon: Remix.mail_line,
                              controller: _emailController,
                              hint: "Enter your email address",
                              keyboardType: TextInputType.emailAddress,
                              validator: Validator.validateEmail,
                              primary: primary,
                              txt: txt,
                              subTxt: subTxt,
                              divider: divider,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      TacticalButton(
                        label: "UPDATE PROFILE",
                        onTap: () => _saveProfile(primary),
                        isLoading: _isSaving,
                        color: primary,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _saveProfile(Color primary) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      bool success = await profileController.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        image: _imageFile,
      );
      setState(() => _isSaving = false);
      if (success) {
        AppSnackbar.show(
          title: "Profile Synchronized",
          message: "Your tactical profile has been updated successfully.",
          isSuccess: true,
        );
        Get.back();
      }
    }
  }

  Widget _sectionHeader(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: color.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildModernField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required Color primary,
    required Color txt,
    required Color subTxt,
    required Color divider,
    bool isLast = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: subTxt,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextFormField(
                      controller: controller,
                      validator: validator,
                      keyboardType: keyboardType,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: txt,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: hint,
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 14,
                          color: subTxt.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            indent: 66,
            endIndent: 20,
            color: divider.withValues(alpha: 0.08),
            height: 1,
          ),
      ],
    );
  }
}

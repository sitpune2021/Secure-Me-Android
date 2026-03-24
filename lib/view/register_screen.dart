import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_me/controller/register_controller/register_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/core/components.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _registerController = Get.put(RegisterController());
  UserRole _selectedRole = UserRole.user;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final roleColor = AppTheme.getThemeForRole(_selectedRole.name).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0XFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const AppBackIcon(color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image Section
            Center(
              child: GestureDetector(
                onTap: () => _showImageSourceActionSheet(context, roleColor),
                child: Stack(
                  children: [
                    Obx(() => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: roleColor.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white10,
                            backgroundImage:
                                _registerController.selectedImage.value != null
                                    ? FileImage(
                                        _registerController.selectedImage.value!)
                                    : null,
                            child: _registerController.selectedImage.value == null
                                ? Icon(Icons.person_outline,
                                    size: 50, color: roleColor)
                                : null,
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: roleColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Role Selection
            Text(
              'I am a:',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: UserRole.values.map((role) {
                final isSelected = _selectedRole == role;
                final thisRoleColor = AppTheme.getThemeForRole(role.name).primaryColor;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedRole = role),
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
            
            // Input Fields
            _buildTextField(
              controller: _nameController,
              hintText: 'Full Name',
              icon: Icons.person_outline,
              roleColor: roleColor,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              hintText: 'Email Address',
              icon: Icons.email_outlined,
              roleColor: roleColor,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              hintText: 'Phone Number',
              icon: Icons.phone_outlined,
              roleColor: roleColor,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              roleColor: roleColor,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Register Button
            Obx(() => ElevatedButton(
              onPressed: _registerController.isLoading.value ? null : () {
                _registerController.registerUser(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  password: _passwordController.text,
                  role: _selectedRole.name,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: roleColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _registerController.isLoading.value 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            )),
            
            const SizedBox(height: 24),
            
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Login',
                    style: TextStyle(color: roleColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context, Color roleColor) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A22),
          borderRadius: BorderRadius.only(
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
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Select Image Source",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Camera",
                  roleColor: roleColor,
                  onTap: () {
                    Get.back();
                    _registerController.pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_outlined,
                  label: "Gallery",
                  roleColor: roleColor,
                  onTap: () {
                    Get.back();
                    _registerController.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color roleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: roleColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color roleColor,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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

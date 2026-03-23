import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());
  UserRole _selectedRole = UserRole.user;
  bool _isPhoneLogin = false;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Current dynamic role color
    final roleColor = _selectedRole == UserRole.helper 
      ? AppTheme.primaryGreen 
      : (_selectedRole == UserRole.police ? AppTheme.primaryBlue : AppTheme.primaryRed);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Secure Me',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Response in 7 Seconds',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: roleColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Role Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: UserRole.values.map((role) {
                  final isSelected = _selectedRole == role;
                  final thisRoleColor = role == UserRole.helper 
                    ? AppTheme.primaryGreen 
                    : (role == UserRole.police ? AppTheme.primaryBlue : AppTheme.primaryRed);
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRole = role),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? thisRoleColor.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? thisRoleColor : Colors.white24,
                        ),
                      ),
                      child: Text(
                        role.name[0].toUpperCase() + role.name.substring(1),
                        style: TextStyle(
                          color: isSelected ? thisRoleColor : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Login Method Toggle
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isPhoneLogin = false),
                      child: Column(
                        children: [
                          Text('Email Login', style: TextStyle(color: !_isPhoneLogin ? roleColor : Colors.white54, fontWeight: !_isPhoneLogin ? FontWeight.bold : FontWeight.normal)),
                          const SizedBox(height: 4),
                          Container(height: 2, color: !_isPhoneLogin ? roleColor : Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isPhoneLogin = true),
                      child: Column(
                        children: [
                          Text('Phone Login', style: TextStyle(color: _isPhoneLogin ? roleColor : Colors.white54, fontWeight: _isPhoneLogin ? FontWeight.bold : FontWeight.normal)),
                          const SizedBox(height: 4),
                          Container(height: 2, color: _isPhoneLogin ? roleColor : Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              if (!_isPhoneLogin)
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: AppTheme.glassBackground,
                    prefixIcon: Icon(Icons.email_outlined, color: roleColor.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                )
              else
                 TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    filled: true,
                    fillColor: AppTheme.glassBackground,
                    prefixIcon: Icon(Icons.phone_outlined, color: roleColor.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                
              const SizedBox(height: 16),
              if (!_isPhoneLogin)
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: AppTheme.glassBackground,
                    prefixIcon: Icon(Icons.lock_outline, color: roleColor.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              const SizedBox(height: 32),
              
              Obx(() => ElevatedButton(
                onPressed: _authController.isLoading.value ? null : () {
                  if (_isPhoneLogin) {
                    _authController.sendPhoneOtp(
                      _phoneController.text.isNotEmpty ? _phoneController.text : '1234567890',
                      _selectedRole,
                    );
                  } else {
                    _authController.login(
                      _emailController.text.isNotEmpty ? _emailController.text : 'test@secureme.com',
                      _passwordController.text,
                      _selectedRole,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: roleColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _authController.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_isPhoneLogin ? 'Send OTP' : 'Login', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.registerView),
                    child: Text('Register', style: TextStyle(color: roleColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

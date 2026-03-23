import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());
  UserRole _selectedRole = UserRole.user;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                color: AppTheme.primaryRed,
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
                return GestureDetector(
                  onTap: () => setState(() => _selectedRole = role),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryRed.withValues(alpha: 0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryRed : Colors.white24,
                      ),
                    ),
                    child: Text(
                      role.name[0].toUpperCase() + role.name.substring(1),
                      style: TextStyle(
                        color: isSelected ? AppTheme.primaryRed : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: AppTheme.glassBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: true,
                fillColor: AppTheme.glassBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            
            Obx(() => ElevatedButton(
              onPressed: _authController.isLoading.value ? null : () {
                _authController.login(
                  _emailController.text.isNotEmpty ? _emailController.text : 'test@secureme.com',
                  'password',
                  _selectedRole,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _authController.isLoading.value 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }
}

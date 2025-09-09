import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // allows UI to move up when keyboard opens
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(), // scroll only if needed
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * 0.025),

                        // Title
                        Text(
                          "Login Account",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.07,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),

                        Text(
                          "Welcome back",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.045,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: Get.height * 0.05),

                        // Login Image
                        Center(
                          child: Image.asset(
                            'assets/images/login.png',
                            height: Get.height * 0.3,
                            width: Get.width * 0.4,
                          ),
                        ),

                        SizedBox(height: Get.height * 0.02),

                        // Mobile Number Label
                        Text(
                          "Mobile Number",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),

                        // Mobile TextField
                        TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (val) {
                            controller.mobileNumber.value = val;
                            if (val.length == 10)
                              FocusScope.of(context).unfocus();
                          },
                        ),

                        SizedBox(height: Get.height * 0.02),

                        // Keep me logged in checkbox
                        Obx(
                          () => Row(
                            children: [
                              Checkbox(
                                value: controller.keepLoggedIn.value,
                                onChanged: controller.toggleKeepLoggedIn,
                              ),
                              const Text("Keep me logged in"),
                            ],
                          ),
                        ),

                        SizedBox(height: Get.height * 0.05),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: Get.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (mobileController.text.length != 10) {
                                Get.snackbar(
                                  "Error",
                                  "Please enter a valid 10-digit mobile number",
                                  backgroundColor: Colors.red.shade100,
                                  colorText: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                controller.login();
                              }
                            },
                            child: Text(
                              "Log In",
                              style: GoogleFonts.poppins(
                                fontSize: Get.width * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: Get.height * 0.03),

                        // OR separator
                        Center(
                          child: Text(
                            'OR',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: Get.height * 0.01),

                        // Create Account Button
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.registerView);
                            },
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColors.lightPrimary,
                              ),
                            ),
                          ),
                        ),

                        Spacer(), // pushes bottom content up
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.05), // responsive padding
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.05),

                Text(
                  "Login Account",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.07,
                    //fontWeight: FontWeight.bold,
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
                Center(
                  child: Image.asset(
                    'assets/images/login.png',
                    height: Get.height * .3,
                    width: Get.width * .4,
                  ),
                ),
                Text(
                  "Mobile Number",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),

                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // only numbers
                    LengthLimitingTextInputFormatter(10), // max 10 digits
                  ],
                  decoration: InputDecoration(
                    hintText: "Enter Mobile Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) {
                    controller.mobileNumber.value = val;

                    // auto close keyboard when 10 digits entered
                    if (val.length == 10) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),

                SizedBox(height: Get.height * 0.02),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

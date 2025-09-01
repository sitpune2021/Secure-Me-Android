import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/login_controller/login_controller.dart';

class LoginView extends StatelessWidget {
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
                  style: TextStyle(
                    fontSize: Get.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.005),

                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                // Image / Illustration
                // Center(
                //   child: Image.asset(
                //     "assets/login.png", // <-- replace with your image
                //     height: Get.height * 0.25,
                //   ),
                // ),
                SizedBox(height: Get.height * 0.05),

                Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),

                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Mobile Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) => controller.mobileNumber.value = val,
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
                    onPressed: controller.login,
                    child: Text(
                      "Log In",
                      style: TextStyle(
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

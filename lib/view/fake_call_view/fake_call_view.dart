import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';

class FakeCallView extends StatelessWidget {
  FakeCallView({super.key});

  final FakeCallController controller = Get.put(FakeCallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: Get.height * 0.03,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Fake Call",
          style: GoogleFonts.poppins(
            fontSize: Get.height * 0.022,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey.shade300, thickness: 1),
            SizedBox(height: Get.height * 0.02),

            // Call Delay
            Text(
              "Set Call Delay",
              style: GoogleFonts.poppins(
                fontSize: Get.height * 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDelayButton("5 Sec"),
                _buildDelayButton("30 Sec"),
                _buildDelayButton("1 Min"),
              ],
            ),

            SizedBox(height: Get.height * 0.03),

            // Caller Selection
            Text(
              "Choose Caller",
              style: GoogleFonts.poppins(
                fontSize: Get.height * 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            _buildCallerItem("assets/images/mom.png", "Mom"),
            _buildCallerItem("assets/images/police.png", "Police"),
            _buildCallerItem("assets/images/boss.png", "Boss"),

            SizedBox(height: Get.height * 0.03),

            // Live Call Duration
            // Obx(() {
            //   int minutes = controller.callDuration.value ~/ 60;
            //   int seconds = controller.callDuration.value % 60;
            //   return Text(
            //     'Call Duration: $minutes:${seconds.toString().padLeft(2, '0')}',
            //     style: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   );
            // }),
            const Spacer(),

            // Start Fake Call Button
            SizedBox(
              width: double.infinity,
              height: Get.height * 0.07,
              child: ElevatedButton(
                onPressed: () async {
                  controller.startCustomFakeCall();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Start Fake Call",
                  style: GoogleFonts.poppins(
                    fontSize: Get.height * 0.022,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelayButton(String text) {
    final FakeCallController controller = Get.find();
    return GestureDetector(
      onTap: () => controller.setDelay(text),
      child: Obx(() {
        bool isSelected = controller.selectedDelay.value == text;
        return Container(
          width: Get.width * 0.25,
          height: Get.height * 0.05,
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.purple : Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.purple : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: Get.height * 0.018,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCallerItem(String imgPath, String name) {
    final FakeCallController controller = Get.find();
    return GestureDetector(
      onTap: () => controller.setCaller(name),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          children: [
            CircleAvatar(
              radius: Get.height * 0.035,
              backgroundImage: AssetImage(imgPath),
            ),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Obx(() {
                bool isSelected = controller.selectedCaller.value == name;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: Get.height * 0.02,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.purple : Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Colors.purple,
                        size: Get.height * 0.03,
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

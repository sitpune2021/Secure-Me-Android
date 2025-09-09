import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/home_controller/home_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/view/community_view/community_view.dart';
import 'package:secure_me/view/track_me_view/track_me_view.dart';
import 'package:secure_me/view/profile_view/profile_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buildBody(controller.currentIndex.value),
        bottomNavigationBar: _buildBottomNav(),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.sosAction,
          backgroundColor: Colors.pink,
          shape: const CircleBorder(),
          child: Text(
            "SOS",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  /// Handle different pages (tabs)
  Widget _buildBody(int index) {
    if (index == 0) {
      return _dashboardUI();
    } else if (index == 1) {
      return TrackMeView();
    } else if (index == 2) {
      return CommunityView();
    } else if (index == 3) {
      return ProfileView();
    } else {
      return _dashboardUI();
    }
  }

  /// Dashboard UI
  Widget _dashboardUI() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(), // scroll only if needed
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row
            Row(
              children: [
                CircleAvatar(radius: Get.width * 0.07),
                SizedBox(width: Get.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello ! Rupa,",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Good Morning !",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: Get.width * 0.05,
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: Get.width * 0.06,
                  ),
                ),
                SizedBox(width: Get.width * 0.03),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notification),
                  child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: Get.width * 0.05,
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: Get.width * 0.06,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.03),

            Text(
              "Helpline Numbers",
              style: GoogleFonts.poppins(
                fontSize: Get.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Get.height * 0.02),

            // Grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: Get.width * 0.04,
              mainAxisSpacing: Get.height * 0.02,
              childAspectRatio: 1.1,
              children: [
                _menuCard("Safe area", "assets/images/safe_area.png"),
                _menuCard("Danger Zone", "assets/images/danger.png"),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.fakecall),
                  child: _menuCard("Fake Call", "assets/images/fake_call.png"),
                ),
                GestureDetector(
                  onTap: () {},
                  child: _menuCard(
                    "Share Live Location",
                    "assets/images/share_location.png",
                  ),
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.02),

            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.shareLiveLocation);
              },
              child: _listTile(
                "Share My Live Location",
                "To upgrade your security share your live location to your near and dear one’s",
                "assets/images/share_location.png",
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.friends),
              child: _listTile(
                "Add Close People",
                "Add close people and friends for SOS",
                "assets/images/add_friend.png",
              ),
            ),

            SizedBox(height: 20), // bottom padding
          ],
        ),
      ),
    );
  }

  Widget _menuCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: Get.height * 0.08),
          SizedBox(height: Get.height * 0.015),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: Get.width * 0.035,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTile(String title, String subtitle, String imagePath) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.02),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Image.asset(imagePath, height: Get.height * 0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.005),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.032,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: Get.width * 0.045,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  /// Bottom navigation bar
  Widget _buildBottomNav() {
    final theme = Theme.of(Get.context!);

    return Obx(
      () => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: AppColors.lightBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => controller.changeTab(0),
              icon: Icon(
                Icons.home,
                color: controller.currentIndex.value == 0
                    ? theme
                          .colorScheme
                          .primary // active
                    : theme.iconTheme.color, // inactive
              ),
            ),
            IconButton(
              onPressed: () => controller.changeTab(1),
              icon: Transform.rotate(
                angle: 45 * 3.1416 / 180,
                child: Icon(
                  Icons.navigation,
                  color: controller.currentIndex.value == 1
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color,
                ),
              ),
            ),
            const SizedBox(width: 40), // space for FAB
            IconButton(
              onPressed: () => controller.changeTab(2),
              icon: Icon(
                Icons.people,
                color: controller.currentIndex.value == 2
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
            ),
            IconButton(
              onPressed: () => controller.changeTab(3),
              icon: Icon(
                Icons.person,
                color: controller.currentIndex.value == 3
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math' as math;
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

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: _buildBody(controller.currentIndex.value, theme, isDark),
        bottomNavigationBar: _buildBottomNav(Theme.of(context)),
        floatingActionButton: buildSosButton(Theme.of(context)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildBody(int index, ThemeData theme, bool isDark) {
    switch (index) {
      case 0:
        return _dashboardUI(theme, isDark);
      case 1:
        return TrackMeView();
      case 2:
        return CommunityView();
      case 3:
        return ProfileView();
      default:
        return _dashboardUI(theme, isDark);
    }
  }

  Widget _dashboardUI(ThemeData theme, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Profile Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: isDark
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        )
                      : const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                  child: CircleAvatar(
                    radius: Get.width * 0.07,
                    backgroundImage: const AssetImage("assets/images/user.jpg"),
                  ),
                ),
                SizedBox(width: Get.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello ! Rupa,",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Good Morning !",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.035,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _gradientCircleIcon(Icons.mic, isDark),
                SizedBox(width: Get.width * 0.03),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notification),
                  child: _gradientCircleIcon(
                    Icons.notifications_outlined,
                    isDark,
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
                color: textColor,
              ),
            ),
            SizedBox(height: Get.height * 0.02),

            // 🔹 Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: Get.width * 0.04,
              mainAxisSpacing: Get.height * 0.02,
              childAspectRatio: 1.1,
              children: [
                _menuCard("Safe area", "assets/images/safe_area.png", isDark),
                _menuCard("Danger Zone", "assets/images/danger.png", isDark),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.fakecall),
                  child: _menuCard(
                    "Fake Call",
                    "assets/images/fake_call.png",
                    isDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: _menuCard(
                    "Share Live Location",
                    "assets/images/share_location.png",
                    isDark,
                  ),
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.02),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.shareLiveLocation),
              child: _listTile(
                "Share My Live Location",
                "To upgrade your security share your live location to your near and dear one’s",
                "assets/images/share_location.png",
                isDark,
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.friends),
              child: _listTile(
                "Add Close People",
                "Add close people and friends for SOS",
                "assets/images/add_friend.png",
                isDark,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(String title, String imagePath, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A001F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: const Color(0xFF9C27B0), width: 1.5)
            : null,
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: const Color(0xFF9C27B0).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: Get.height * 0.08,
            color: isDark ? Colors.white : null,
          ),
          SizedBox(height: Get.height * 0.015),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: Get.width * 0.035,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTile(
    String title,
    String subtitle,
    String imagePath,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.02),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A001F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: const Color(0xFF9C27B0), width: 1.5)
            : null,
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: const Color(0xFF9C27B0).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: Get.height * 0.08,
            color: isDark ? Colors.white : null,
          ),
          SizedBox(width: Get.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Get.height * 0.005),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.032,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: Get.width * 0.045,
            color: isDark ? Colors.white : Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _gradientCircleIcon(IconData icon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isDark
            ? const LinearGradient(
                colors: [Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.pink.withOpacity(0.6)
                : Colors.black.withOpacity(0.1),
            blurRadius: isDark ? 15 : 4,
            spreadRadius: isDark ? 2 : 1,
            offset: isDark ? const Offset(0, 0) : const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(Get.width * 0.02),
      child: Icon(
        icon,
        color: isDark ? Colors.white : Colors.black87,
        size: Get.width * 0.055,
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return CustomPaint(
      painter: CurvedNavBarPainter(
        isDark ? const Color(0xFF0D0D0D) : Colors.white,
      ),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => controller.changeTab(0),
              icon: Icon(
                Icons.home,
                color: controller.currentIndex.value == 0
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            IconButton(
              onPressed: () => controller.changeTab(1),
              icon: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Icon(
                  Icons.navigation,
                  color: controller.currentIndex.value == 1
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.white70 : Colors.black54),
                ),
              ),
            ),
            const SizedBox(width: 40), // space for SOS button
            IconButton(
              onPressed: () => controller.changeTab(2),
              icon: Icon(
                Icons.people,
                color: controller.currentIndex.value == 2
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            IconButton(
              onPressed: () => controller.changeTab(3),
              icon: Icon(
                Icons.person,
                color: controller.currentIndex.value == 3
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SOS Button
  Widget buildSosButton(ThemeData theme) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.sosActivate),
      child: Container(
        width: 65, // Fixed size instead of relative
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "SOS",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom Nav Painter
class CurvedNavBarPainter extends CustomPainter {
  final Color color;
  CurvedNavBarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double notchRadius = 35; // match SOS radius (~65/2)

    Path path = Path()..moveTo(0, 0);

    // Left edge
    path.lineTo(centerX - notchRadius - 20, 0);

    // Curve for notch
    path.quadraticBezierTo(
      centerX,
      -notchRadius, // deeper curve
      centerX + notchRadius + 20,
      0,
    );

    // Rest of navbar
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/home_controller/home_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
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

    double height = Get.height;
    double width = Get.width;

    return Obx(
      () => Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: _buildBody(controller.currentIndex.value, theme, isDark),
        bottomNavigationBar: _buildBottomNav(isDark, height, width),
        floatingActionButton: buildSosButton(isDark, height, width),
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

    double height = Get.height;
    double width = Get.width;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Profile Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.01),
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
                    radius: width * 0.07,
                    backgroundImage: const AssetImage("assets/images/user.jpg"),
                  ),
                ),
                SizedBox(width: width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello ! Rupa,",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Good Morning !",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.035,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _gradientCircleIcon(Icons.mic, isDark, width),
                SizedBox(width: width * 0.03),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notification),
                  child: _gradientCircleIcon(
                    Icons.notifications_outlined,
                    isDark,
                    width,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            Text(
              "Helpline Numbers",
              style: GoogleFonts.poppins(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: height * 0.02),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: width * 0.04,
              mainAxisSpacing: height * 0.02,
              childAspectRatio: 1.1,
              children: [
                _menuCard(
                  "Safe area",
                  "assets/images/safe_area.png",
                  isDark,
                  height,
                  width,
                ),
                _menuCard(
                  "Danger Zone",
                  "assets/images/danger.png",
                  isDark,
                  height,
                  width,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.fakecall),
                  child: _menuCard(
                    "Fake Call",
                    "assets/images/fake_call.png",
                    isDark,
                    height,
                    width,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: _menuCard(
                    "Share Live Location",
                    "assets/images/share_location.png",
                    isDark,
                    height,
                    width,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.shareLiveLocation),
              child: _listTile(
                "Share My Live Location",
                "To upgrade your security share your live location to your near and dear one’s",
                "assets/images/share_location.png",
                isDark,
                height,
                width,
              ),
            ),
            SizedBox(height: height * 0.015),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.friends),
              child: _listTile(
                "Add Close People",
                "Add close people and friends for SOS",
                "assets/images/add_friend.png",
                isDark,
                height,
                width,
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    String title,
    String imagePath,
    bool isDark,
    double height,
    double width,
  ) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: height * 0.08,
            color: isDark ? Colors.white : null,
          ),
          SizedBox(height: height * 0.015),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
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
    double height,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.02),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A001F)],
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
            height: height * 0.08,
            color: isDark ? Colors.white : null,
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.032,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: width * 0.045,
            color: isDark ? Colors.white : Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _gradientCircleIcon(IconData icon, bool isDark, double width) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isDark
            ? const LinearGradient(colors: [Colors.purple, Colors.pink])
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
      padding: EdgeInsets.all(width * 0.02),
      child: Icon(
        icon,
        color: isDark ? Colors.white : Colors.black87,
        size: width * 0.055,
      ),
    );
  }

  // SOS Button
  Widget buildSosButton(bool isDark, double height, double width) {
    double bottomPadding =
        MediaQuery.of(Get.context!).viewPadding.bottom + height * 0.01;

    return Positioned(
      bottom: bottomPadding, // place above home indicator
      left: (width / 2) - (width * 0.08), // center horizontally
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.sosActivate),
        child: Container(
          width: width * 0.16,
          height: width * 0.16,
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
                fontSize: width * 0.045,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom Navigation
  Widget _buildBottomNav(bool isDark, double height, double width) {
    double bottomPadding =
        MediaQuery.of(Get.context!).viewPadding.bottom + height * 0.01;

    return CustomPaint(
      painter: CurvedNavBarPainter(
        isDark ? const Color(0xFF0D0D0D) : Colors.white,
        height,
        width,
      ),
      child: SizedBox(
        height: height * 0.09 + bottomPadding,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
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
              SizedBox(width: width * 0.15), // space for SOS button
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
      ),
    );
  }
}

// Custom Painter for Bottom Nav
class CurvedNavBarPainter extends CustomPainter {
  final Color color;
  final double height;
  final double width;
  CurvedNavBarPainter(this.color, this.height, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double notchRadius = width * 0.08; // match SOS radius

    Path path = Path()..moveTo(0, 0);
    path.lineTo(centerX - notchRadius - 10, 0);

    path.quadraticBezierTo(
      centerX,
      -notchRadius, // deeper curve
      centerX + notchRadius + 10,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

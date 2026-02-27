import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/controller/home_controller/home_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:secure_me/view/community_view/community_view.dart';
import 'package:secure_me/view/track_me_view/track_me_view.dart';
import 'package:secure_me/view/profile_view/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController profileController = Get.put(ProfileController());
  String greeting = "Good Morning";

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  // Data is already being fetched/observed by profileController

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (mounted) {
      setState(() {
        if (hour >= 0 && hour < 12) {
          greeting = "Good Morning ☀️";
        } else if (hour >= 12 && hour < 17) {
          greeting = "Good Afternoon 🌤️";
        } else if (hour >= 17 && hour < 21) {
          greeting = "Good Evening 🌆";
        } else {
          greeting = "Good Night 🌙";
        }
      });
    }
    dev.log('👋 Greeting set to: $greeting (Hour: $hour)', name: 'HomeView');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;
      final effectiveDark = userOverride
          ? isDark
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;
      return Scaffold(
        backgroundColor: effectiveDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: _buildBody(controller.currentIndex.value, effectiveDark),
        bottomNavigationBar: _buildBottomNav(effectiveDark),
        floatingActionButton: buildSosButton(effectiveDark),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  Widget _buildBody(int index, bool effectiveDark) {
    switch (index) {
      case 0:
        return _dashboardUI(effectiveDark);
      case 1:
        return const TrackMeView();
      case 2:
        return const CommunityView();
      case 3:
        return const ProfileView();
      default:
        return _dashboardUI(effectiveDark);
    }
  }

  Widget _dashboardUI(bool effectiveDark) {
    final textColor = effectiveDark ? AppColors.darkText : AppColors.lightText;

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
                  decoration: effectiveDark
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary(effectiveDark),
                              AppColors.secondary(effectiveDark),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary(
                                effectiveDark,
                              ).withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        )
                      : const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                  child: Container(
                    width: width * 0.14,
                    height: width * 0.14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary(effectiveDark),
                          AppColors.secondary(effectiveDark),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: width * 0.08,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Obx(() {
                    final name = profileController.userData['name'] ?? "User";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hello, $name!",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          greeting,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.035,
                            color: effectiveDark
                                ? AppColors.darkHint
                                : AppColors.lightHint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  }),
                ),
                // Removed Spacer to prevent layout overflow on narrow screens
                SizedBox(width: width * 0.02),
                _gradientCircleIcon(Icons.mic, effectiveDark, width),
                SizedBox(width: width * 0.03),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notification),
                  child: _gradientCircleIcon(
                    Icons.notifications_outlined,
                    effectiveDark,
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
                  effectiveDark,
                  height,
                  width,
                ),
                _menuCard(
                  "Danger Zone",
                  "assets/images/danger.png",
                  effectiveDark,
                  height,
                  width,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.fakecall),
                  child: _menuCard(
                    "Fake Call",
                    "assets/images/fake_call.png",
                    effectiveDark,
                    height,
                    width,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: _menuCard(
                    "Share Live Location",
                    "assets/images/share_location.png",
                    effectiveDark,
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
                effectiveDark,
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
                effectiveDark,
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
    bool effectiveDark,
    double height,
    double width,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: effectiveDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A001F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        borderRadius: BorderRadius.circular(18),
        border: effectiveDark
            ? Border.all(color: AppColors.primary(effectiveDark), width: 1.5)
            : null,
        boxShadow: [
          if (effectiveDark)
            BoxShadow(
              color: AppColors.primary(effectiveDark).withValues(alpha: 0.6),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
            color: effectiveDark ? Colors.white : null,
          ),
          SizedBox(height: height * 0.015),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w600,
              color: effectiveDark ? Colors.white : Colors.black87,
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
    bool effectiveDark,
    double height,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.02),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: effectiveDark
            ? const LinearGradient(
                colors: [Color(0xFF0D0D0D), Color(0xFF1A001F)],
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        borderRadius: BorderRadius.circular(18),
        border: effectiveDark
            ? Border.all(color: AppColors.primary(effectiveDark), width: 1.5)
            : null,
        boxShadow: [
          if (effectiveDark)
            BoxShadow(
              color: AppColors.primary(effectiveDark).withValues(alpha: 0.6),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
            color: effectiveDark ? Colors.white : null,
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
                    color: effectiveDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.032,
                    color: effectiveDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: width * 0.045,
            color: effectiveDark ? Colors.white : Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _gradientCircleIcon(IconData icon, bool effectiveDark, double width) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: effectiveDark
            ? LinearGradient(
                colors: [
                  AppColors.primary(effectiveDark),
                  AppColors.secondary(effectiveDark),
                ],
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        boxShadow: [
          BoxShadow(
            color: effectiveDark
                ? AppColors.primary(effectiveDark).withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: effectiveDark ? 15 : 4,
            spreadRadius: effectiveDark ? 1 : 1,
            offset: effectiveDark ? const Offset(0, 0) : const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(width * 0.02),
      child: Icon(
        icon,
        color: effectiveDark ? Colors.white : Colors.black87,
        size: width * 0.055,
      ),
    );
  }

  // SOS Button
  Widget buildSosButton(bool effectiveDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.sosActivate),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary(effectiveDark),
              AppColors.secondary(effectiveDark),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            // Deep Inner Shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            // Primary Glow
            BoxShadow(
              color: AppColors.primary(effectiveDark).withValues(alpha: 0.7),
              blurRadius: 25,
              spreadRadius: 5,
            ),
            // Base Button Shading
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            // Core Intense Red Glow
            const BoxShadow(
              color: AppColors.sosRed,
              blurRadius: 40,
              spreadRadius: 4,
            ),
            // Outer Ambient Red Aura
            BoxShadow(
              color: AppColors.sosRed.withValues(alpha: 0.6),
              blurRadius: 65,
              spreadRadius: 10,
            ),
            // Soft Bloom
            BoxShadow(
              color: AppColors.sosRed.withValues(alpha: 0.4),
              blurRadius: 100,
              spreadRadius: 25,
            ),
            // Ultra-Wide Ambient Glow
            BoxShadow(
              color: AppColors.sosRed.withValues(alpha: 0.2),
              blurRadius: 140,
              spreadRadius: 45,
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFFFF5252), // Lighter red top-left
                AppColors.sosRed, // Base red
              ],
              center: Alignment(-0.3, -0.3),
              radius: 0.8,
            ),
          ),
          child: const Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Premium Floating Bottom Navigation Bar ──────────────────────────────────
  Widget _buildBottomNav(bool effectiveDark) {
    final bgColor = effectiveDark ? AppColors.darkCard : AppColors.lightCard;
    final primaryColor = effectiveDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final secondaryColor = effectiveDark
        ? AppColors.darkSecondary
        : AppColors.lightSecondary;
    final inactiveColor = AppColors.hint(effectiveDark);
    final bottomPad = MediaQuery.of(Get.context!).viewPadding.bottom;

    const navItems = [
      _NavItem(icon: Icons.dashboard_rounded, label: 'Home'),
      _NavItem(icon: Icons.near_me_rounded, label: 'Track'),
      _NavItem(icon: Icons.diversity_3_rounded, label: 'Contacts'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: effectiveDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveDark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: effectiveDark ? 0.15 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            // Left 2 items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(2, (i) {
                  final active = controller.currentIndex.value == i;
                  return Flexible(
                    child: _NavButton(
                      item: navItems[i],
                      active: active,
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                      inactiveColor: inactiveColor,
                      onTap: () => controller.changeTab(i),
                    ),
                  );
                }),
              ),
            ),
            // Centre gap for SOS
            const SizedBox(width: 72),
            // Right 2 items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(2, (i) {
                  final idx = i + 2;
                  final active = controller.currentIndex.value == idx;
                  return Flexible(
                    child: _NavButton(
                      item: navItems[idx],
                      active: active,
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                      inactiveColor: inactiveColor,
                      onTap: () => controller.changeTab(idx),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Nav Item Data ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─── Nav Button ────────────────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool active;
  final Color primaryColor;
  final Color secondaryColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.primaryColor,
    required this.secondaryColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animated pill background
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: active
                  ? BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: AnimatedScale(
                scale: active ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(
                  item.icon,
                  size: 22,
                  color: active ? primaryColor : inactiveColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: active ? 10.5 : 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? primaryColor : inactiveColor,
              ),
              child: Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Bottom Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: active ? 4 : 0,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

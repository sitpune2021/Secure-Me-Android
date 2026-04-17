import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/controller/home_controller/home_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/view/fake_call_view/fake_call_view.dart';
import 'package:secure_me/view/manager_dashboard.dart';
import 'package:secure_me/view/safety_radar_view.dart';
import 'package:secure_me/view/profile/profile_view/profile_view.dart';
import 'package:secure_me/controller/voice_controller/voice_controller.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController profileController = Get.put(ProfileController());
  final VoiceController voiceController = Get.put(VoiceController());
  String greeting = "Good Morning";

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

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
      final theme = themeController.theme;
      return Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _buildBody(controller.currentIndex.value),
          bottomNavigationBar: _buildBottomNav(),
          floatingActionButton: buildSosButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const ManagerDashboard();
      case 1:
        return const SafetyRadarView();
      case 2:
        return FakeCallView();
      case 3:
        return const ProfileView();
      default:
        return _dashboardUI();
    }
  }

  Widget _dashboardUI() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Modern Header ────────────────────────────────────────────────────────
            _buildModernHeader(),
            
            const SizedBox(height: 32),
            
            // ── SOS Activation Panel (Modern) ────────────────────────────────────────
            _buildSOSStatusPanel(),

            const SizedBox(height: 32),

            // ── Slide to Activate SOS (New Feature) ──────────────────────────────────
            _buildSlideToSOS(),

            const SizedBox(height: 32),

            // ── Quick Support Section (Grid) ────────────────────────────────────────
            Text(
              "QUICK SENTINELS",
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildSentinelGrid(),

            const SizedBox(height: 32),

            // ── Recent Activity / Action Cards ──────────────────────────────────────
            Text(
              "ACTIVE MONITORING",
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              title: "SECURITY HUB",
              subtitle: "Configure emergency protocols",
              icon: Remix.shield_keyhole_fill,
              color: Colors.indigo,
              onTap: () => Get.toNamed(AppRoutes.setting),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              title: "GUARDIAN SENTINELS",
              subtitle: "Manage your secure network",
              icon: Remix.team_fill,
              color: Theme.of(context).primaryColor,
              onTap: () => Get.toNamed(AppRoutes.contactList),
            ),

            const SizedBox(height: 120), // Padding for SOS button
            ], // Children
          ), // Column
        ), // SingleChildScrollView
      ), // ConstrainedBox
    ), // Center
  ); // SafeArea
}

  Widget _buildModernHeader() {
    final name = profileController.userData['name'] ?? "Manager";
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 2),
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFE0E0E0),
            backgroundImage: AssetImage('assets/images/logo.png'), 
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        _buildHeaderIcon(Remix.notification_3_line, () => Get.toNamed(AppRoutes.notification)),
        const SizedBox(width: 12),
        _buildHeaderIcon(Remix.settings_3_line, () => Get.toNamed(AppRoutes.setting)),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.2);
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
        ),
      ),
    );
  }

  Widget _buildSOSStatusPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "SECURE CONNECTION ACTIVE",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Icon(Remix.shield_check_fill, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "System Standby",
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Emergency protocols primed and ready",
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    ).animate().scale(duration: const Duration(milliseconds: 400), curve: Curves.easeOutBack);
  }

  Widget _buildSlideToSOS() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        const double sliderSize = 64;
        final RxDouble slidePos = 0.0.obs;

        return Container(
          height: sliderSize,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(sliderSize / 2),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              // Sliding Track Text
              Center(
                child: Text(
                  "SLIDE TO ACTIVATE SOS",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: const Duration(seconds: 2), color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),

              // Sliding Handle
              Obx(() => Positioned(
                    left: slidePos.value,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final newPos = slidePos.value + details.delta.dx;
                        slidePos.value = newPos.clamp(0.0, width - sliderSize);
                      },
                      onHorizontalDragEnd: (details) {
                        if (slidePos.value > width * 0.7) {
                          // ACTIVATE
                          slidePos.value = width - sliderSize;
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Get.toNamed(AppRoutes.sosActivate);
                            slidePos.value = 0.0;
                          });
                        } else {
                          // RETURN
                          slidePos.value = 0.0;
                        }
                      },
                      child: Container(
                        height: sliderSize,
                        width: sliderSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Remix.arrow_right_s_line, color: Colors.white, size: 28),
                      ),
                    ).animate(target: slidePos.value == 0 ? 0 : 1).shimmer(duration: const Duration(seconds: 1)),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSentinelGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        _buildSentinelCard(
          "SAFE AREA", 
          Remix.shield_cross_fill, 
          Colors.purple,
          () => Get.toNamed(AppRoutes.location),
        ),
        _buildSentinelCard(
          "DANGER ZONE", 
          Remix.error_warning_fill, 
          Colors.redAccent,
          () => Get.toNamed(AppRoutes.location),
        ),
        _buildSentinelCard(
          "FAKE CALL", 
          Remix.phone_find_fill, 
          Colors.cyan,
          () => Get.toNamed(AppRoutes.fakecall),
        ),
        _buildSentinelCard(
          "SIGNAL RADAR", 
          Remix.radar_line, 
          Colors.blueAccent,
          () => Get.toNamed(AppRoutes.safetyRadar),
        ),
      ],
    );
  }

  Widget _buildSentinelCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Icon(Remix.arrow_right_s_line, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 400)).slideX(begin: 0.05),
    );
  }

  Widget _buildBottomNav() {
    final navItems = [
      _NavItem(icon: Remix.dashboard_3_line, label: "HQ"),
      _NavItem(icon: Remix.radar_line, label: "RADAR"),
      _NavItem(icon: Remix.phone_find_fill, label: "FAKE"),
      _NavItem(icon: Remix.user_6_line, label: "ADMIN"),
    ];

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (i) => _buildNavItem(navItems[i], i)),
                ),
              ),
              const SizedBox(width: 80), // Space for SOS button
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (i) => _buildNavItem(navItems[i + 2], i + 2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, int index) {
    return Obx(() {
      final bool active = controller.currentIndex.value == index;
      final Color activeColor = Theme.of(context).primaryColor;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: active ? activeColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: active ? activeColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildSosButton() {
    const primaryColor = AppTheme.primaryRed;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.sosActivate),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72,
        width: 72,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [primaryColor, Color(0xFFD32F2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.4),
              blurRadius: 32,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Remix.error_warning_fill, color: Colors.white, size: 28)
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: const Duration(milliseconds: 1500), color: Colors.white70),
              Text(
                "SOS",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05),
            duration: const Duration(milliseconds: 800),
          ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

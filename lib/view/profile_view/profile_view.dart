import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;

      final effectiveDark = userOverride
          ? isDark
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;

      // All colors strictly from AppColors
      final textColor = AppColors.text(effectiveDark);
      final subTextColor = AppColors.hint(effectiveDark);
      final backgroundColor = AppColors.background(effectiveDark);
      final cardColor = AppColors.card(effectiveDark);
      final dividerColor = AppColors.divider(effectiveDark);
      final primaryColor = AppColors.primary(effectiveDark);
      final secondaryColor = AppColors.secondary(effectiveDark);

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          surfaceTintColor: AppColors.transparent,
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: Platform.isAndroid ? false : true,
          iconTheme: IconThemeData(color: textColor),
          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "Profile",
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (profileController.isLoading.value) {
            return _ProfileShimmer(
              effectiveDark: effectiveDark,
              cardColor: cardColor,
            );
          }

          final userData = profileController.userData;
          final name = userData['name'] as String? ?? 'User';
          final email = userData['email'] as String? ?? 'email@example.com';
          final phone = userData['phone_no'] as String? ?? '+91 XXXXXXXXXX';
          final userRole = userData['user_role'] as String?;
          final createdAt = userData['created_at'] as String?;
          final profileImage = userData['profile_image'] as String?;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ══════════════════════════════════════════════
                // HERO AVATAR + INFO CARD
                // ══════════════════════════════════════════════
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: primaryColor.withValues(
                          alpha: effectiveDark ? 0.22 : 0.12,
                        ),
                        width: 1.5,
                      ),
                      boxShadow: [
                        // Deep Soft Shadow
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: effectiveDark ? 0.45 : 0.08,
                          ),
                          blurRadius: 45,
                          offset: const Offset(0, 22),
                          spreadRadius: -12,
                        ),
                        // Primary Ambient Glow
                        BoxShadow(
                          color: primaryColor.withValues(
                            alpha: effectiveDark ? 0.35 : 0.14,
                          ),
                          blurRadius: 55,
                          spreadRadius: -15,
                          offset: const Offset(0, 18),
                        ),
                        // Inner Highlight for Glassy look
                        if (!effectiveDark)
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.7),
                            blurRadius: 0,
                            offset: const Offset(1.5, 1.5),
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ── Full gradient header band ──
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.3, 0.9],
                              ),
                            ),
                            child: Stack(
                              children: [
                                // ── Premium Mesh Highlight 1 ──
                                Positioned(
                                  top: -60,
                                  left: -50,
                                  child: Container(
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.28),
                                          Colors.white.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // ── Premium Mesh Highlight 2 ──
                                Positioned(
                                  bottom: -80,
                                  right: -50,
                                  child: Container(
                                    width: 240,
                                    height: 240,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          secondaryColor.withValues(alpha: 0.6),
                                          secondaryColor.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // ── Subtle Pattern overlay (visual texture) ──
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.05,
                                    child: CustomPaint(
                                      painter: _PatternPainter(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // ── Actual row content ──
                                Row(
                                  children: [
                                    // ── Left: Avatar Section ──
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                              width: 2.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.35,
                                                ),
                                                blurRadius: 25,
                                                offset: const Offset(0, 12),
                                              ),
                                              BoxShadow(
                                                color: primaryColor.withValues(
                                                  alpha: 0.3,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: 48,
                                            backgroundImage:
                                                profileImage != null &&
                                                    profileImage.isNotEmpty
                                                ? NetworkImage(
                                                    "${AppUrl.host}/$profileImage",
                                                  )
                                                : null,
                                            backgroundColor: Colors.white
                                                .withValues(alpha: 0.2),
                                            child:
                                                profileImage == null ||
                                                    profileImage.isEmpty
                                                ? Icon(
                                                    Icons.person_rounded,
                                                    size: 52,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  )
                                                : null,
                                          ),
                                        ],
                                    ),
                                    const SizedBox(width: 22),

                                    // ── Center: Info Section ──
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: -0.6,
                                              height: 1.1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          _InfoRow(
                                            icon: Icons.email_outlined,
                                            value: email,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          _InfoRow(
                                            icon: Icons.phone_outlined,
                                            value: phone,
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                          ),
                                          if (userRole != null) ...[
                                            const SizedBox(height: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.22,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.verified_rounded,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    userRole.toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white,
                                                      letterSpacing: 0.8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ── Member-since footer band ──
                        if (createdAt != null)
                          Container(
                            decoration: BoxDecoration(
                              color: effectiveDark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : primaryColor.withValues(alpha: 0.04),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(32),
                              ),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.08),
                                width: 0.8,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 22,
                            ),
                            child: Row(
                              children: [
                                // Date badge
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    size: 19,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MEMBER SINCE",
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: subTextColor.withValues(
                                          alpha: 0.65,
                                        ),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Text(
                                      createdAt.split('T')[0],
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Status chip
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [primaryColor, secondaryColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "ACTIVE",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ══════════════════════════════════════════════
                // ACCOUNT SECTION
                // ══════════════════════════════════════════════
                _MenuCard(
                  title: "Account",
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  primary: primaryColor,
                  textColor: textColor,
                  effectiveDark: effectiveDark,
                  items: [
                    _MenuItemData(
                      icon: Icons.person_outline_rounded,
                      label: "Edit Profile",
                      iconBgColor: primaryColor,
                      onTap: () => Get.toNamed(AppRoutes.editProfile),
                    ),
                    _MenuItemData(
                      icon: Icons.location_on_outlined,
                      label: "Location",
                      iconBgColor: AppColors.green,
                      onTap: () => Get.toNamed(AppRoutes.location),
                    ),
                    _MenuItemData(
                      icon: Icons.diversity_1_rounded,
                      label: "Emergency Contacts",
                      iconBgColor: AppColors.accent,
                      onTap: () => Get.toNamed(AppRoutes.contactList),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Preference SECTION
                _MenuCard(
                  title: "Preferences",
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  primary: primaryColor,
                  textColor: textColor,
                  effectiveDark: effectiveDark,
                  items: [
                    _MenuItemData(
                      icon: Icons.notifications_outlined,
                      label: "Push Notifications",
                      iconBgColor: _MenuCard.purpleAccent,
                      onTap: () => Get.toNamed(AppRoutes.pushnotification),
                    ),
                    _MenuItemData(
                      icon: Icons.settings_outlined,
                      label: "Settings",
                      iconBgColor: AppColors.darkPrimary,
                      onTap: () => Get.toNamed(AppRoutes.setting),
                    ),
                    _MenuItemData(
                      icon: Icons.brightness_6_outlined,
                      label: "Theme Mode",
                      iconBgColor: _MenuCard.pinkAccent,
                      onTap: () => Get.toNamed(AppRoutes.theme),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Security & Privacy SECTION
                _MenuCard(
                  title: "Security & Privacy",
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  primary: primaryColor,
                  textColor: textColor,
                  effectiveDark: effectiveDark,
                  items: [
                    _MenuItemData(
                      icon: Icons.security_rounded,
                      label: "Account Security",
                      iconBgColor: AppColors.accent,
                      onTap: () {},
                    ),
                    _MenuItemData(
                      icon: Icons.privacy_tip_outlined,
                      label: "Privacy Policy",
                      iconBgColor: _MenuCard.blueAccent,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ══════════════════════════════════════════════
                // MORE SECTION
                // ══════════════════════════════════════════════
                _MenuCard(
                  title: "More",
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  primary: primaryColor,
                  textColor: textColor,
                  effectiveDark: effectiveDark,
                  items: [
                    _MenuItemData(
                      icon: Icons.info_outline_rounded,
                      label: "About Us",
                      iconBgColor: AppColors.greenAccent,
                      onTap: () {},
                    ),
                    _MenuItemData(
                      icon: Icons.help_outline_rounded,
                      label: "Help & Support",
                      iconBgColor: AppColors.accent,
                      onTap: () {},
                    ),
                    _MenuItemData(
                      icon: Icons.logout_rounded,
                      label: "Log Out",
                      iconBgColor: AppColors.red,
                      onTap: () => profileController.logout(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // App Branding & Version
                Center(
                  child: Column(
                    children: [
                      Text(
                        "S E C U R E   M E",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: textColor.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "VERSION 1.0.0",
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: textColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      );
    });
  }
}

// ─── InfoRow helper ──────────────────────────────────────────────────────────

// ─── Menu Card ────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final String title;
  final List<_MenuItemData> items;
  static const Color blueAccent = Colors.blueAccent;
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;
  final Color textColor;
  final Color cardColor;
  final Color dividerColor;
  final Color primary;
  final bool effectiveDark;

  const _MenuCard({
    required this.title,
    required this.items,
    required this.textColor,
    required this.cardColor,
    required this.dividerColor,
    required this.primary,
    required this.effectiveDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: primary.withValues(alpha: effectiveDark ? 0.15 : 0.08),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: effectiveDark ? 0.45 : 0.08),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 35,
            spreadRadius: -10,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: textColor.withValues(alpha: 0.5),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                _MenuItemTile(
                  data: item,
                  isLast: index == items.length - 1,
                  textColor: textColor,
                  primary: primary,
                  effectiveDark: effectiveDark,
                ),
                if (index < items.length - 1)
                  Divider(
                    color: dividerColor.withValues(alpha: 0.5),
                    height: 1,
                    indent: 64,
                    endIndent: 20,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItemData data;
  final bool isLast;
  final Color textColor;
  final Color primary;
  final bool effectiveDark;

  const _MenuItemTile({
    required this.data,
    required this.isLast,
    required this.textColor,
    required this.primary,
    required this.effectiveDark,
  });

  @override
  Widget build(BuildContext context) {
    final isDestructive = data.label.toLowerCase().contains('log out');
    final activeColor = isDestructive ? Colors.redAccent : primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(28))
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: data.iconBgColor.withValues(
                    alpha: effectiveDark ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: data.iconBgColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(data.icon, color: activeColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data.label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? Colors.redAccent : textColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: textColor.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final Color iconBgColor;
  final VoidCallback onTap;

  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.iconBgColor,
    required this.onTap,
  });
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Custom Painter for subtle background pattern ──────────────────────────
class _PatternPainter extends CustomPainter {
  final Color color;
  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gap = 30.0;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Shimmer Skeleton ─────────────────────────────────────────────────────────
class _ProfileShimmer extends StatelessWidget {
  final bool effectiveDark;
  final Color cardColor;

  const _ProfileShimmer({required this.effectiveDark, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final baseColor = effectiveDark ? Colors.grey[850]! : Colors.grey[200]!;
    final highlightColor = effectiveDark ? Colors.grey[800]! : Colors.grey[50]!;

    return Shimmer.fromColors(
      baseColor: baseColor.withValues(alpha: 0.8),
      highlightColor: highlightColor.withValues(alpha: 0.8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 24),
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

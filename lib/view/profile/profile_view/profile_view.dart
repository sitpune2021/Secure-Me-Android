import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:remixicon/remixicon.dart';

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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Remix.logout_box_line, color: Colors.red, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              "Sign Out",
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Are you sure you want to end your session?",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("Cancel", style: GoogleFonts.outfit(color: Theme.of(context).hintColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      profileController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Sign Out", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (profileController.isLoading.value) {
          return _buildShimmer(context);
        }

        final userData = profileController.userData;
        final name = userData['name'] as String? ?? 'User';
        final email = userData['email'] as String? ?? 'email@example.com';
        final phone = userData['phone_no'] as String? ?? 'Not available';
        final role = userData['user_role'] as String? ?? 'User';
        final profileImage = userData['profile_image'] as String?;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context, name, role, profileImage),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("QUICK ACTIONS"),
                    const SizedBox(height: 12),
                    _buildQuickActionGrid(context),
                    const SizedBox(height: 32),
                    _buildSectionHeader("PERSONAL INFORMATION"),
                    const SizedBox(height: 12),
                    _buildInfoCard(context, [
                      _InfoItem(icon: Remix.mail_line, label: "Email", value: email),
                      _InfoItem(icon: Remix.phone_line, label: "Phone", value: phone),
                    ]),
                    const SizedBox(height: 32),
                    _buildSectionHeader("PREFERENCES"),
                    const SizedBox(height: 12),
                    _buildMenuSection(context, [
                      _MenuData(icon: Remix.notification_4_line, label: "Notifications", color: Colors.indigo, route: AppRoutes.pushnotification),
                      _MenuData(icon: Remix.palette_line, label: "Appearance", color: Colors.pink, route: AppRoutes.theme),
                      _MenuData(icon: Remix.shield_user_line, label: "Privacy & Security", color: Colors.teal),
                    ]),
                    const SizedBox(height: 32),
                    _buildSectionHeader("SUPPORT"),
                    const SizedBox(height: 12),
                    _buildMenuSection(context, [
                      _MenuData(icon: Remix.question_line, label: "Help Center", color: Colors.blue),
                      _MenuData(icon: Remix.information_line, label: "About Secure Me", color: Colors.amber),
                      _MenuData(icon: Remix.logout_box_r_line, label: "Sign Out", color: Colors.red, isDestructive: true),
                    ]),
                    const SizedBox(height: 48),
                    Center(
                      child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          "VERSION 2.0.1",
                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context, String name, String role, String? image) {
    final primaryColor = Theme.of(context).primaryColor;
    final scafBg = Theme.of(context).scaffoldBackgroundColor;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: scafBg,
      automaticallyImplyLeading: false, // Ensure no back button is shown
      actions: [
        IconButton(
          icon: const Icon(Remix.settings_3_line),
          onPressed: () => Get.toNamed(AppRoutes.setting),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Mesh Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    primaryColor.withValues(alpha: 0.8),
                    primaryColor.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            // Decorative Circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Profile Info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Avatar with premium border
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: scafBg.withValues(alpha: 0.2),
                      backgroundImage: image != null ? NetworkImage(AppUrl.buildImageUrl(image)) : null,
                      child: image == null ? const Icon(Remix.user_3_fill, size: 40, color: Colors.white) : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Remix.shield_check_fill, size: 12, color: Colors.white.withValues(alpha: 0.9)),
                      const SizedBox(width: 6),
                      Text(
                        role.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildActionTile(context, Remix.edit_box_line, "Edit Profile", Colors.blue, () => Get.toNamed(AppRoutes.editProfile)),
        _buildActionTile(context, Remix.map_pin_user_line, "Locations", Colors.green, () => Get.toNamed(AppRoutes.location)),
        _buildActionTile(context, Remix.contacts_line, "Contacts", Colors.orange, () => Get.toNamed(AppRoutes.contactList)),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoItem> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.indexOf(item) == items.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Icon(item.icon, size: 20, color: Theme.of(context).hintColor),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: GoogleFonts.outfit(fontSize: 11, color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
                      Text(item.value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              if (!isLast) Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<_MenuData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.indexOf(item) == items.length - 1;
          return Column(
            children: [
              ListTile(
                onTap: item.isDestructive ? () => _showLogoutDialog(context) : (item.route != null ? () => Get.toNamed(item.route!) : null),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.label, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: item.isDestructive ? Colors.red : null)),
                trailing: const Icon(Remix.arrow_right_s_line, size: 18),
              ),
              if (!isLast) Divider(indent: 60, endIndent: 20, color: Theme.of(context).dividerColor.withValues(alpha: 0.1), height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
      highlightColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
      child: Center(child: Text("LOADING PROFILE...", style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  _InfoItem({required this.icon, required this.label, required this.value});
}

class _MenuData {
  final IconData icon;
  final String label;
  final Color color;
  final String? route;
  final bool isDestructive;
  _MenuData({required this.icon, required this.label, required this.color, this.route, this.isDestructive = false});
}

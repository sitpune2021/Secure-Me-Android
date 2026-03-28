import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: const Icon(Remix.arrow_left_line),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: Text(
              "NOTIFICATIONS",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Remix.more_2_fill),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LATEST ALERTS",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Mark all as read",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildNotificationCard(context, index);
                },
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, int index) {
    final List<Map<String, dynamic>> items = [
      {
        "title": "Emergency Alert Triggered",
        "desc": "An SOS signal was detected in your nearby circle",
        "time": "2 mins ago",
        "icon": Remix.error_warning_fill,
        "color": Colors.red,
        "isRead": false,
      },
      {
        "title": "Safe Zone Entered",
        "desc": "Sarah has entered the designated Safe Zone",
        "time": "1 hour ago",
        "icon": Remix.shield_check_fill,
        "color": Colors.green,
        "isRead": true,
      },
      {
        "title": "Security Protocol Updated",
        "desc": "End-to-end encryption successfully verified",
        "time": "3 hours ago",
        "icon": Remix.lock_2_fill,
        "color": Colors.blue,
        "isRead": true,
      },
      {
        "title": "New Sentinel Added",
        "desc": "John Doe is now tracking your location",
        "time": "Yesterday",
        "icon": Remix.user_add_fill,
        "color": Colors.purple,
        "isRead": true,
      },
      {
        "title": "Danger Zone Warning",
        "desc": "High crime activity reported in your current area",
        "time": "2 days ago",
        "icon": Remix.alarm_warning_fill,
        "color": Colors.orange,
        "isRead": true,
      },
    ];

    final item = items[index % items.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: item["isRead"] ? Colors.transparent : (item["color"] as Color).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (item["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item["icon"], color: item["color"], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item["title"],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item["isRead"])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: item["color"],
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["desc"],
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Theme.of(context).hintColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["time"],
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.1),
      ),
    );
  }
}

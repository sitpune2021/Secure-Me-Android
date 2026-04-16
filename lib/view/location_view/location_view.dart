import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/view_model/location_view_model.dart';
import 'package:get/get.dart'; // Keeping Get for navigation if needed, but reducing its footprint

class LocationView extends ConsumerWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBackgroundTrackingEnabled = ref.watch(locationViewModelProvider);

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
              "LOCATION",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SIGNAL PREFERENCES",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumSwitchCard(
                    context,
                    ref,
                    "Background Tracking",
                    "Ensure sentinel connectivity always",
                    Remix.radar_fill,
                    Colors.blue,
                    isBackgroundTrackingEnabled,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "TACTICAL TOOLS",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    context,
                    "Satellite View",
                    "View real-world terrain and markers",
                    Remix.earth_fill,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    "Safe Zones",
                    "Manage active protection boundaries",
                    Remix.shield_user_fill,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSwitchCard(
    BuildContext context,
    WidgetRef ref,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).hintColor)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) => ref.read(locationViewModelProvider.notifier).toggleBackgroundTracking(v),
            activeThumbColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).hintColor)),
                    ],
                  ),
                ),
                Icon(Remix.arrow_right_s_line, color: Theme.of(context).hintColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/helper_controller/helper_controller.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/view/helper_dashboard/helper_alert_view.dart';
import 'package:secure_me/view/helper_dashboard/helper_active_view.dart';

class HelperDashboard extends StatefulWidget {
  const HelperDashboard({super.key});

  @override
  State<HelperDashboard> createState() => _HelperDashboardState();
}

class _HelperDashboardState extends State<HelperDashboard> {
  int _currentSector = 0;

  final List<Widget> _sectors = [
    const HelperCommandSector(),
    const HelperHistorySector(),
    const SafetyGuidelineSector(),
    const HelperProfileSector(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(HelperController());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentSector,
        children: _sectors,
      ),
      bottomNavigationBar: _buildTacticalNavBar(primaryColor, isDark),
    );
  }

  Widget _buildTacticalNavBar(Color primaryColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.05))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(0, Remix.shield_flash_fill, "COMMAND"),
              _buildNavButton(1, Remix.history_fill, "HISTORY"),
              _buildNavButton(2, Remix.book_read_fill, "SAFETY"),
              _buildNavButton(3, Remix.user_6_fill, "PROFILE"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isSelected = _currentSector == index;
    Color buttonColor;
    if (index == 0) {
      buttonColor = Colors.green;
    } else if (index == 1) {
      buttonColor = Colors.blue;
    } else if (index == 2) {
      buttonColor = Colors.orange;
    } else {
      buttonColor = Colors.purple;
    }

    return GestureDetector(
      onTap: () => setState(() => _currentSector = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? buttonColor : Colors.grey.withValues(alpha: 0.5), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? buttonColor : Colors.grey.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
        ],
      ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
    );
  }
}

// Sector 1: Main Dashboard
class HelperCommandSector extends StatelessWidget {
  const HelperCommandSector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelperController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        _buildSliverHeader(context, controller, isDark),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _buildSafetyShortcut(context),
                 const SizedBox(height: 32),
                 _buildSectionLabel(context, "NEARBY EMERGENCY REQUESTS"),
                 const SizedBox(height: 16),
                 _buildNearbyList(context, controller),
                 const SizedBox(height: 32),
                 SizedBox(
                   width: double.infinity,
                   child: OutlinedButton.icon(
                     onPressed: () => Get.to(() => HelperAlertView(signal: HelperEmergencySignal(
                        id: "SIG-999",
                        victimName: "Sarah J.",
                        distance: "150m away",
                        time: "Simulated",
                        severity: "High",
                        latitude: 18.5224,
                        longitude: 73.8587,
                     ))),
                     icon: const Icon(Remix.test_tube_fill, size: 16),
                     label: const Text("SIMULATE INCOMING ALERT"),
                     style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                     ),
                   ),
                 ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverHeader(BuildContext context, HelperController controller, bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SUPPORT UNIT",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "HELPER DASH",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                Obx(() => Switch.adaptive(
                  value: controller.isOnline.value,
                  onChanged: (v) => controller.toggleAvailability(v),
                  activeThumbColor: Colors.green,
                )),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(target: LatLng(18.5204, 73.8567), zoom: 14),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: const MarkerId('victim_1'),
                    position: const LatLng(18.5224, 73.8587),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    infoWindow: const InfoWindow(title: "In Danger"),
                  ),
                  Marker(
                    markerId: const MarkerId('helper_1'),
                    position: const LatLng(18.5214, 73.8547),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    infoWindow: const InfoWindow(title: "Nearby Helper"),
                  ),
                  Marker(
                    markerId: const MarkerId('police_1'),
                    position: const LatLng(18.5234, 73.8597),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    infoWindow: const InfoWindow(title: "Police Unit"),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyShortcut(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Remix.error_warning_fill, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CRITICAL SAFETY PROTOCOL",
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.orange, letterSpacing: 0.5),
                ),
                Text(
                  "Do not engage in violence. Wait for police.",
                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Remix.arrow_right_s_line, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildNearbyList(BuildContext context, HelperController controller) {
    final mockRequests = [
      HelperEmergencySignal(
        id: "SIG-501",
        victimName: "Anonymous",
        distance: "200m away",
        time: "Just now",
        severity: "High",
        latitude: 18.5224,
        longitude: 73.8587,
      ),
      HelperEmergencySignal(
        id: "SIG-502",
        victimName: "Simran K.",
        distance: "500m away",
        time: "2m ago",
        severity: "Medium",
        latitude: 18.5254,
        longitude: 73.8547,
      ),
    ];

    return Column(
      children: mockRequests.map((req) => _buildRequestCard(context, req)).toList(),
    );
  }

  Widget _buildRequestCard(BuildContext context, HelperEmergencySignal req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (req.severity == "High" ? Colors.red : Colors.orange).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Remix.alarm_warning_fill, color: (req.severity == "High" ? Colors.red : Colors.orange), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      req.victimName,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "${req.distance} • ${req.time}",
                      style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                    ),
                  ],
                ),
              ),
              _buildTacticalBadge(req.severity, req.severity == "High" ? Colors.red : Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _showAcceptConfirmation(context, req),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                "ACCEPT REQUEST",
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5),
      ),
    );
  }

  void _showAcceptConfirmation(BuildContext context, HelperEmergencySignal signal) {
     Get.dialog(
       Dialog(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
         child: Padding(
           padding: const EdgeInsets.all(32),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               const Icon(Remix.shield_user_fill, color: Colors.green, size: 64),
               const SizedBox(height: 24),
               Text(
                 "CONFIRM ASSISTANCE",
                 style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900),
               ),
               const SizedBox(height: 8),
               Text(
                 "By accepting, you commit to assisting ${signal.victimName} safely. Police have been notified.",
                 textAlign: TextAlign.center,
                 style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
               ),
               const SizedBox(height: 32),
               Row(
                 children: [
                   Expanded(
                     child: TextButton(
                       onPressed: () => Get.back(),
                       child: Text("CANCEL", style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.w900)),
                     ),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: ElevatedButton(
                       onPressed: () {
                         Get.find<HelperController>().acceptCase(signal);
                         Get.back();
                         Get.to(() => HelperActiveView(signal: signal));
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       ),
                       child: const Text("I'LL HELP"),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ),
       ),
     );
  }
}

// Sector 2: History
class HelperHistorySector extends StatelessWidget {
  const HelperHistorySector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelperController>();
    
    return Container(
       padding: const EdgeInsets.all(24),
       child: SafeArea(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               "PAST CONTRIBUTIONS",
               style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blue, letterSpacing: 2),
             ),
             Text(
               "HELP HISTORY",
               style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
             ),
             const SizedBox(height: 32),
             
             // Stats Row
             Row(
               children: [
                 _buildStatCard("TOTAL HELPS", controller.totalHelped.toString(), Colors.blue),
                 const SizedBox(width: 16),
                 _buildStatCard("SUCCESSFUL", controller.successfulAssists.toString(), Colors.green),
               ],
             ),
             
             const SizedBox(height: 48),
             Text(
               "RECENT ASSISTS",
               style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5),
             ),
             const SizedBox(height: 16),
             Expanded(
               child: Obx(() => ListView.builder(
                 itemCount: controller.helpHistory.length,
                 itemBuilder: (context, index) {
                   final req = controller.helpHistory[index];
                   return _buildHistoryItem(context, req);
                 },
               )),
             ),
           ],
         ),
       ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: color, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, HelperEmergencySignal req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Remix.checkbox_circle_fill, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(req.victimName, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Text("${req.time} • ${req.status}", style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Remix.arrow_right_s_line, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

// Sector 3: Safety Guidelines
class SafetyGuidelineSector extends StatelessWidget {
  const SafetyGuidelineSector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HELPER PROTOCOL",
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.orange, letterSpacing: 2),
            ),
             Text(
               "SAFETY FIRST",
               style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
             ),
             const SizedBox(height: 32),
             Expanded(
               child: ListView(
                 children: [
                   _buildGuidelineItem(
                     Remix.prohibited_line,
                     "NO VIOLENCE",
                     "Do not engage in physical combat or violence. Your role is as a supporter, not a vigilante.",
                     Colors.red,
                   ),
                   _buildGuidelineItem(
                     Remix.police_car_fill,
                     "WAIT FOR POLICE",
                     "If the situation is dangerous, stay back and wait for professionals. Monitor from a distance.",
                     Colors.blue,
                   ),
                   _buildGuidelineItem(
                     Remix.walk_fill,
                     "SAFE ESCORT",
                     "The best way to help is to escort the user to a public area or stay nearby until they feel safe.",
                     Colors.green,
                   ),
                   _buildGuidelineItem(
                     Remix.phone_fill,
                     "CONTACT POLICE",
                     "Always ensure the police are on their way. Provide live updates via the coordination channel.",
                     Colors.orange,
                   ),
                   const SizedBox(height: 40),
                   Container(
                     padding: const EdgeInsets.all(24),
                     decoration: BoxDecoration(
                       color: Colors.grey.withValues(alpha: 0.05),
                       borderRadius: BorderRadius.circular(24),
                       border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                     ),
                     child: Text(
                       "By using this dashboard, you agree to prioritize life and safety over intervention. Misuse of the platform or violation of these protocols result in permanent account ban.",
                       textAlign: TextAlign.center,
                       style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                     ),
                   ),
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
                const SizedBox(height: 4),
                Text(description, style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sector 4: Profile
class HelperProfileSector extends StatelessWidget {
  const HelperProfileSector({super.key});

  @override
  Widget build(BuildContext context) {
    final helperController = Get.find<HelperController>();
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final user = authController.user.value;
      if (user == null) return const Center(child: CircularProgressIndicator());

      return CustomScrollView(
        slivers: [
          _buildProfileHeader(context, user, isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(helperController),
                  const SizedBox(height: 32),
                  _buildSectionLabel(context, "ACCOUNT DETAILS"),
                  const SizedBox(height: 16),
                  _buildInfoTile(context, Remix.mail_fill, "Email Address", user.email, Colors.blue),
                  _buildInfoTile(context, Remix.phone_fill, "Phone Number", user.phone, Colors.green),
                  _buildInfoTile(context, Remix.map_pin_2_fill, "Service Area", "5km Radius", Colors.orange),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.editProfile),
                      icon: const Icon(Remix.edit_box_line, size: 18),
                      label: Text("UPDATE TACTICAL PROFILE", style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionLabel(context, "PREFERENCES"),
                  const SizedBox(height: 16),
                  _buildSettingsToggle(
                    context, 
                    Remix.notification_4_fill, 
                    "Crisis Alerts", 
                    "Priority emergency notifications", 
                    true, 
                    Colors.indigo
                  ),
                  _buildSettingsToggle(
                    context, 
                    Remix.shield_user_fill, 
                    "Stealth Mode", 
                    "Anonymous while responding", 
                    false, 
                    Colors.teal
                  ),
                  const SizedBox(height: 40),
                  _buildLogoutButton(context, authController),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProfileHeader(BuildContext context, user, bool isDark) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(top: 80, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple.withValues(alpha: 0.3), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple.withValues(alpha: 0.1),
                    child: const Icon(Remix.user_6_fill, size: 50, color: Colors.purple),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Remix.check_line, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              user.name.toUpperCase(),
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            Text(
              "VERIFIED SUPPORT UNIT",
              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.purple, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(HelperController controller) {
    return Row(
      children: [
        _buildCompactStat("RANK", "#124", Colors.amber),
        const SizedBox(width: 12),
        _buildCompactStat("LEVEL", "Guardian", Colors.purple),
        const SizedBox(width: 12),
        _buildCompactStat("RATING", "4.9/5", Colors.green),
      ],
    );
  }

  Widget _buildCompactStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
                Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle(BuildContext context, IconData icon, String title, String subtitle, bool value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: (v) {}, activeThumbColor: color),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthController authController) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton.icon(
        onPressed: () => _showLogoutDialog(context, authController),
        icon: const Icon(Remix.logout_box_r_line, color: Colors.red),
        label: Text(
          "SIGN OUT OF SERVICE",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.red, letterSpacing: 1),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Remix.logout_circle_fill, color: Colors.red, size: 64),
              const SizedBox(height: 24),
              Text("END SERVICE?", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(
                "You will no longer receive emergency alerts while signed out.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text("STAY ACTIVE", style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("SIGN OUT"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

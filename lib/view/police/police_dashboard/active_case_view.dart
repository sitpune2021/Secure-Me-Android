import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:secure_me/controller/police_controller/police_controller.dart';
import 'package:secure_me/controller/emergency_navigation_controller.dart';
import 'package:secure_me/view/emergency_chat_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveCaseView extends StatefulWidget {
  final EmergencySignal signal;
  const ActiveCaseView({super.key, required this.signal});

  @override
  State<ActiveCaseView> createState() => _ActiveCaseViewState();
}

class _ActiveCaseViewState extends State<ActiveCaseView> {
  final PoliceController _policeController = Get.find<PoliceController>();
  final EmergencyNavigationController _navController = Get.put(EmergencyNavigationController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Live Map View
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.signal.latitude, widget.signal.longitude),
              zoom: 16,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: {
               Marker(
                 markerId: const MarkerId('victim'),
                 position: LatLng(widget.signal.latitude, widget.signal.longitude),
                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
               ),
            },
          ),

          // Top Bar Actions
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildCircularAction(
                    icon: Remix.arrow_left_line,
                    onTap: () => Get.back(),
                    isDark: isDark,
                  ),
                  const Spacer(),
                  _buildCircularAction(
                    icon: Remix.navigation_fill,
                    onTap: () => _openMaps(),
                    isDark: isDark,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Information
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CASE PROTECTOR ACTIVE",
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                widget.signal.victimName,
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                "0.8 km distance | Responding from HQ",
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "04:22",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    
                    // Quick Action Tools
                    Row(
                      children: [
                        _buildActionTool(
                          icon: Remix.phone_fill,
                          label: "CALL USER",
                          color: Colors.blue,
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildActionTool(
                          icon: Remix.chat_smile_2_fill,
                          label: "GROUP CHAT",
                          color: primaryColor,
                          onTap: () => Get.to(() => const EmergencyChatView(groupId: "SOS-991")),
                        ),
                        const SizedBox(width: 12),
                        _buildActionTool(
                          icon: Remix.direction_fill,
                          label: "SAFE PATH",
                          color: Colors.green,
                          onTap: () {
                            _navController.calculateEscapeRoute(LatLng(widget.signal.latitude, widget.signal.longitude));
                            Get.snackbar(
                              "ESCAPE ROUTE", 
                              "A safe tactical path has been calculated for the responder team.",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.all(20),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _buildSectionLabel(context, "RESPONDERS & HELPERS"),
                    const SizedBox(height: 16),
                    _buildHelperList(),
                    
                    const SizedBox(height: 32),
                    _buildTacticalConfirm(context, primaryColor),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircularAction({required IconData icon, required VoidCallback onTap, required bool isDark, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color ?? (isDark ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.8)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color != null ? Colors.white : (isDark ? Colors.white : Colors.black), size: 20),
      ),
    );
  }

  Widget _buildActionTool({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildHelperList() {
    // Mocking helper state
    final mockHelpers = [
      HelperInfo(name: 'Rahul K.', status: 'on_way', role: 'Gym Person'),
      HelperInfo(name: 'Aditya S.', status: 'reached', role: 'Civilian'),
      HelperInfo(name: 'Vikram J.', status: 'accepted', role: 'Gym Person'),
    ];

    return Column(
      children: mockHelpers.map((helper) => _buildHelperItem(helper)).toList(),
    );
  }

  Widget _buildHelperItem(HelperInfo helper) {
    Color statusColor = Colors.orange;
    String statusText = "ON THE WAY";
    IconData statusIcon = Remix.steering_2_fill;

    if (helper.status == 'reached') {
      statusColor = Colors.green;
      statusText = "REACHED";
      statusIcon = Remix.checkbox_circle_fill;
    } else if (helper.status == 'accepted') {
      statusColor = Colors.blue;
      statusText = "ACCEPTED";
      statusIcon = Remix.check_double_fill;
    }

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
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(helper.name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(helper.role, style: GoogleFonts.outfit(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
              ],
            ),
          ),
          _buildTacticalBadge(statusText, statusColor),
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

  Widget _buildTacticalConfirm(BuildContext context, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () => _showResolveDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          "MARK AS RESOLVED",
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      ),
    );
  }

  void _showResolveDialog() {
    final notesController = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Remix.checkbox_circle_fill, color: Colors.green, size: 64),
              const SizedBox(height: 24),
              Text(
                "RESOLVE INCIDENT",
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                "Briefly describe the action taken.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter incident notes...",
                  hintStyle: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text("CANCEL", style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _policeController.resolveCase(notesController.text);
                        Get.back(); // close dialog
                        Get.back(); // exit active case view
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("SUBMIT"),
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

  Future<void> _openMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${widget.signal.latitude},${widget.signal.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

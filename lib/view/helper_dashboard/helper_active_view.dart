import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:secure_me/controller/helper_controller/helper_controller.dart';
import 'package:secure_me/view/police/police_dashboard/tactical_chat_view.dart';

class HelperActiveView extends StatefulWidget {
  final HelperEmergencySignal signal;
  const HelperActiveView({super.key, required this.signal});

  @override
  State<HelperActiveView> createState() => _HelperActiveViewState();
}

class _HelperActiveViewState extends State<HelperActiveView> {
  final HelperController _helperController = Get.find<HelperController>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Live Map tracking
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
              // Markers for other responders would be added here
            },
          ),

          // Top Bar
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
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          // Info Overlay
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
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -10)),
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
                                "SUPPORT UNIT ACTIVE",
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                widget.signal.victimName,
                                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "${widget.signal.distance} from your location",
                                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        _buildTimerBadge(),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _buildQuickActions(context, primaryColor),
                    
                    const SizedBox(height: 32),
                    _buildRepondersList(context),

                    const SizedBox(height: 32),
                    _buildCompletionButton(context),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        "02:45",
        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.red),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color primaryColor) {
    return Row(
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
          onTap: () => Get.to(() => const TacticalChatView(groupName: "SUPPORT GROUP")),
        ),
      ],
    );
  }

  Widget _buildRepondersList(BuildContext context) {
    final mockResponders = [
      SupportInfo(name: "Officer Verma", role: "Police", status: "on_way"),
      SupportInfo(name: "Anil S. (Gym)", role: "Helper", status: "reached"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EN ROUTE / ARRIVED",
          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        ...mockResponders.map((r) => _buildResponderItem(context, r)),
      ],
    );
  }

  Widget _buildResponderItem(BuildContext context, SupportInfo r) {
    final isPolice = r.role == "Police";
    return Container(
       margin: const EdgeInsets.only(bottom: 12),
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         color: isPolice ? Colors.blue.withValues(alpha: 0.05) : Theme.of(context).cardColor,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
       ),
       child: Row(
         children: [
           CircleAvatar(
             radius: 16,
             backgroundColor: isPolice ? Colors.blue : Colors.green,
             child: Icon(isPolice ? Remix.police_car_fill : Remix.user_heart_fill, color: Colors.white, size: 14),
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(r.name, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold)),
                 Text(r.role, style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
               ],
             ),
           ),
           Text(
             r.status.toUpperCase().replaceAll("_", " "),
             style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: r.status == "reached" ? Colors.green : Colors.orange),
           ),
         ],
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
                style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: color, letterSpacing: 1),
              ),
            ],
          ),
        ),
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

  Widget _buildCompletionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _showCompletionDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          "I HAVE ASSISTED",
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    bool wasSuccessful = true;
    final notesController = TextEditingController();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "HELP SUMMARY",
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            StatefulBuilder(builder: (context, setModalState) {
              return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCompletionOption(
                         "I SUCCESSFULLY HELPED",
                         Remix.checkbox_circle_fill,
                         Colors.green,
                         wasSuccessful,
                         () => setModalState(() => wasSuccessful = true),
                      ),
                      const SizedBox(height: 12),
                      _buildCompletionOption(
                         "COULDN'T REACH / OTHERS HELPED",
                         Remix.close_circle_fill,
                         Colors.red,
                         !wasSuccessful,
                         () => setModalState(() => wasSuccessful = false),
                      ),
                    ],
                  );
            }),
            const SizedBox(height: 24),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: "Add any feedback or notes...",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   _helperController.completeHelp(wasSuccessful, notesController.text);
                   Get.back(); // close modal
                   Get.back(); // exit active view
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("SUBMIT COMPLETION"),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCompletionOption(String label, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey,
                ),
              ),
            ),
          ],
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

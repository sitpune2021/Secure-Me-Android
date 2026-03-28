import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/police_controller/police_controller.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:remixicon/remixicon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/view/police/police_dashboard/active_case_view.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  final PoliceController _policeController = Get.put(PoliceController());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final primaryColor = Theme.of(context).primaryColor;
      
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _currentIndex == 2 ? null : _buildAppBar(context),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildCommandCenter(context),
            _buildIncidentHistory(context),
            _buildOfficerDossier(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(context, primaryColor),
      );
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        _currentIndex == 0 ? 'TACTICAL COMMAND' : 'INCIDENT REGISTER', 
        style: GoogleFonts.outfit(
          fontSize: 16, 
          fontWeight: FontWeight.w900, 
          letterSpacing: 2,
          color: primaryColor,
        ),
      ),
      actions: [
        Obx(() => Container(
          margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _policeController.isOnline.value 
              ? Colors.green.withValues(alpha: 0.1) 
              : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _policeController.isOnline.value ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _policeController.isOnline.value ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _policeController.isOnline.value ? 'ONLINE' : 'OFFLINE',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: _policeController.isOnline.value ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.white24 : Colors.black26,
        selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Remix.radar_line), label: 'COMMAND'),
          BottomNavigationBarItem(icon: Icon(Remix.history_line), label: 'REGISTER'),
          BottomNavigationBarItem(icon: Icon(Remix.user_6_line), label: 'DOSSIER'),
        ],
      ),
    );
  }

  Widget _buildCommandCenter(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTacticalMap(context),
          const SizedBox(height: 32),
          
          _buildSectionHeader(context, 'ACTIVE EMERGENCY ALERTS'),
          const SizedBox(height: 16),
          _buildAlertList(context),
          
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'QUICK STATS & METRICS'),
          const SizedBox(height: 16),
          _buildStatsGrid(context),
        ],
      ),
    );
  }

  Widget _buildTacticalMap(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(18.5204, 73.8567),
            zoom: 14,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          markers: {
             Marker(
               markerId: const MarkerId('active_victim'),
               position: const LatLng(18.5254, 73.8617),
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
             ),
             Marker(
               markerId: const MarkerId('helper_1'),
               position: const LatLng(18.5154, 73.8517),
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
             ),
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title, 
      style: GoogleFonts.outfit(
        fontSize: 11, 
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.5,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildAlertList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat()).fade(duration: const Duration(milliseconds: 800)),
              const SizedBox(width: 12),
              Text(
                'HIGH SEVERITY ALERT', 
                style: GoogleFonts.outfit(
                  fontSize: 11, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.red,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                'just now', 
                style: GoogleFonts.outfit(
                  fontSize: 11, 
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Remix.user_voice_fill, color: AppTheme.primaryRed, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avinash Magar', 
                      style: GoogleFonts.outfit(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '0.8 km away | Police Station Sector 4', 
                      style: GoogleFonts.outfit(
                        fontSize: 12, 
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTacticalAction(
                  context: context,
                  label: 'ACCEPT CASE',
                  icon: Remix.checkbox_circle_fill,
                  color: Colors.green,
                  onTap: () {
                    final mockSignal = EmergencySignal(
                      id: "SIG-001",
                      victimName: "Avinash Magar",
                      distance: "0.8 km",
                      time: "just now",
                      severity: "High",
                      latitude: 18.5254,
                      longitude: 73.8617,
                    );
                    _policeController.acceptCase(mockSignal);
                    Get.to(() => ActiveCaseView(signal: mockSignal));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTacticalAction(
                  context: context,
                  label: 'DECLINE',
                  icon: Remix.close_circle_fill,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  onTap: () {
                     _policeController.declineCase();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  Widget _buildTacticalAction({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildStatCard(context, 'ACTIVE', _policeController.activeCasesCount.value.toString(), AppTheme.primaryRed),
        _buildStatCard(context, 'RESOLVED', _policeController.resolvedCasesCount.value.toString(), Colors.green),
        _buildStatCard(context, 'PENDING', _policeController.pendingResponsesCount.value.toString(), Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentHistory(BuildContext context) {
    if (_policeController.caseHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Remix.archive_fill, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
            const SizedBox(height: 24),
            Text(
              'REGISTRY IS EMPTY',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _policeController.caseHistory.length,
      itemBuilder: (context, index) {
        final item = _policeController.caseHistory[index];
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
                   _buildTacticalBadge("RESOLVED", Colors.green),
                   const Spacer(),
                   Text(
                     item.time,
                     style: GoogleFonts.outfit(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
                   ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Remix.check_double_line, color: Colors.green, size: 18),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.victimName, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(item.distance, style: GoogleFonts.outfit(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
                      ],
                    ),
                  ),
                  const Icon(Remix.arrow_right_s_line, size: 18, color: Colors.grey),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTacticalBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildOfficerDossier(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Profile Header
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Remix.check_fill, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'OFFICER AVINASH',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          Text(
            'BADGE ID: #SPH-2021 | SECTOR 4',
            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 1),
          ),
          
          const SizedBox(height: 48),
          
          // Tactical Settings
          _buildSettingsHeader(context, 'COMMAND PREFERENCES'),
          const SizedBox(height: 12),
          _buildTacticalToggle(
            label: 'AVAILABILITY STATUS',
            subLabel: _policeController.isOnline.value ? 'Online & receiving alerts' : 'Currently offline',
            value: _policeController.isOnline.value,
            onChanged: (v) => _policeController.toggleAvailability(v),
            primaryColor: primaryColor,
          ),
          
          const SizedBox(height: 24),
          _buildSettingsHeader(context, 'SERVICE TOOLS'),
          const SizedBox(height: 12),
          _buildTacticalOption(context, Remix.shield_flash_line, 'Operational Status', 'Normal Operations'),
          _buildTacticalOption(context, Remix.map_pin_2_line, 'Assigned Sector', 'Pune East Division'),
          _buildTacticalOption(context, Remix.logout_box_r_line, 'Deactivate Shield', 'Logout from Command', isRed: true, onTap: () => Get.find<AuthController>().logout()),
          
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title, 
          style: GoogleFonts.outfit(
            fontSize: 11, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildTacticalToggle({
    required String label,
    required String subLabel,
    required bool value,
    required Function(bool) onChanged,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subLabel, style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalOption(BuildContext context, IconData icon, String label, String subLabel, {bool isRed = false, VoidCallback? onTap}) {
    final color = isRed ? Colors.red : Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                  Text(subLabel, style: GoogleFonts.outfit(fontSize: 11, color: color.withValues(alpha: 0.5))),
                ],
              ),
            ),
            Icon(Remix.arrow_right_s_line, size: 18, color: color.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/add_contact_controller/add_contact_controller.dart';
import 'package:secure_me/core/utils/validator.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final ThemeController themeController = Get.find<ThemeController>();
  final AddContactController addContactController =
      Get.isRegistered<AddContactController>()
      ? Get.find<AddContactController>()
      : Get.put(AddContactController());

  String _selectedRole = "Police";
  int _priority = 1;
  bool _isNotifyOnSos = true;
  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;

  final List<String> _roles = [
    "Police",
    "Manager",
    "Gym_Person",
    "Family",
    "Friend",
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();

    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['isEdit'] == true) {
      final contact = args['contact'];
      if (contact != null) {
        addContactController.isEditing.value = true;
        addContactController.editingContactId.value = contact.id ?? -1;

        _phoneController.text = contact.phoneNo ?? "";
        _emailController.text = contact.email ?? "";
        _priority = contact.priority;
        _isNotifyOnSos = contact.isNotifyOnSos;

        // Pre-fill lat/long if contact already has them
        if (contact.latitude != null) _latitude = contact.latitude;
        if (contact.longitude != null) _longitude = contact.longitude;

        final name = contact.name ?? "";
        final parts = name.split(" ");
        _firstnameController.text = parts.isNotEmpty ? parts[0] : "";
        _lastnameController.text = parts.length > 1
            ? parts.sublist(1).join(" ")
            : "";

        if (_roles.contains(contact.userRole)) {
          _selectedRole = contact.userRole!;
        }
      }
    } else {
      addContactController.isEditing.value = false;
      addContactController.editingContactId.value = -1;
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        dev.log("Location services disabled", name: "AddContactView");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          dev.log("Location permission denied", name: "AddContactView");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        dev.log(
          "Location permission permanently denied",
          name: "AddContactView",
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });

      dev.log(
        "Location fetched: lat=$_latitude, lng=$_longitude",
        name: "AddContactView",
      );
    } catch (e) {
      dev.log("Location error: $e", name: "AddContactView");
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      addContactController.addContact(
        name:
            '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}',
        phoneNo: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        userRole: _selectedRole,
        priority: _priority,
        isNotifyOnSos: _isNotifyOnSos,
        latitude: _latitude,
        longitude: _longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Remix.arrow_left_line),
            onPressed: () => Get.back(),
          ),
          title: Text(
            addContactController.isEditing.value
                ? "Update Sentinel"
                : "New Sentinel",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Header
                Center(
                  child:
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Remix.shield_user_line,
                          size: 48,
                          color: primaryColor,
                        ),
                      ).animate().scale(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                      ),
                ),
                const SizedBox(height: 16),

                // Location Status Indicator
                _buildLocationStatus(primaryColor),

                const SizedBox(height: 24),

                // Basic Information
                _buildFieldLabel("BASIC INFORMATION"),
                const SizedBox(height: 16),
                _buildModernField(
                  controller: _firstnameController,
                  label: "First Name",
                  icon: Remix.user_line,
                  validator: Validator.validateName,
                ),
                const SizedBox(height: 16),
                _buildModernField(
                  controller: _lastnameController,
                  label: "Last Name",
                  icon: Remix.user_line,
                ),
                const SizedBox(height: 16),
                _buildModernField(
                  controller: _phoneController,
                  label: "Mobile Number",
                  icon: Remix.phone_line,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: Validator.validatePhone,
                ),
                const SizedBox(height: 16),
                _buildModernField(
                  controller: _emailController,
                  label: "Email Address",
                  icon: Remix.mail_line,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? null
                      : Validator.validateEmail(v),
                ),

                const SizedBox(height: 32),
                _buildFieldLabel("SENTINEL ROLE"),
                const SizedBox(height: 16),
                _buildRoleSelection(primaryColor),

                const SizedBox(height: 32),
                _buildFieldLabel("EMERGENCY CONFIGURATION"),
                const SizedBox(height: 16),
                _buildPrioritySelection(primaryColor),
                const SizedBox(height: 16),
                _buildSosToggle(primaryColor),

                const SizedBox(height: 48),

                // Action Button
                SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: addContactController.isLoading.value
                            ? null
                            : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: addContactController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                addContactController.isEditing.value
                                    ? "Update Sentinel"
                                    : "Initialize Sentinel",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Shows live location fetch status below the header icon
  Widget _buildLocationStatus(Color primary) {
    if (_isFetchingLocation) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, color: primary),
          ),
          const SizedBox(width: 8),
          Text(
            "Fetching location...",
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      );
    }

    if (_latitude != null && _longitude != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Remix.map_pin_2_line, size: 14, color: Colors.green),
          const SizedBox(width: 6),
          Text(
            "Location ready (${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)})",
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.green),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _fetchLocation,
            child: Icon(Remix.refresh_line, size: 14, color: primary),
          ),
        ],
      );
    }

    // Location unavailable — show retry
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Remix.map_pin_line, size: 14, color: Colors.orange),
        const SizedBox(width: 6),
        Text(
          "Location unavailable",
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.orange),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: _fetchLocation,
          child: Text(
            "Retry",
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.outfit(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(
            color: Theme.of(context).hintColor,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _roles.map((role) {
          final isSelected = _selectedRole == role;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedRole = role);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                role.replaceAll('_', ' ').toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).hintColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrioritySelection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "EMERGENCY PRIORITY",
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "RANK $_priority",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [1, 2, 3, 4, 5].map((p) {
              final isSelected = _priority == p;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _priority = p);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected ? primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    p.toString(),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).hintColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            "Rank 1 gets alerted first. Higher ranks follow if no response.",
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: Theme.of(context).hintColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSosToggle(Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: Material(
        // ← wrap with Material
        color: Colors.transparent, // ← keep container color visible
        borderRadius: BorderRadius.circular(20),
        child: SwitchListTile(
          value: _isNotifyOnSos,
          onChanged: (val) => setState(() => _isNotifyOnSos = val),
          title: Text(
            "NOTIFY DURING SOS",
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Automatically alert this contact when SOS is triggered.",
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: Theme.of(context).hintColor,
            ),
          ),
          activeThumbColor: primary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}

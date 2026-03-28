import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/contact_controller/contact_controller.dart';
import 'package:secure_me/model/contact_model.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final ContactController controller = Get.put(ContactController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (controller.hasMore.value && !controller.isLoading.value) {
        controller.fetchContacts(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme-Aware Tactical Design
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor =
        theme.textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : Colors.black87);
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Premium Tactical Appbar ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: scaffoldBg,
            leading: IconButton(
              icon: Icon(Remix.arrow_left_s_line, color: textColor),
              onPressed: () => Get.back(),
            ),
            title: Text(
              "GUARDIAN SENTINELS",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Remix.user_add_line,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                onPressed: () => Get.toNamed(AppRoutes.addContact),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withValues(alpha: isDark ? 0.15 : 0.05),
                          scaffoldBg,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child:
                        Icon(
                              Remix.shield_user_fill,
                              size: 80,
                              color: primaryColor.withValues(
                                alpha: isDark ? 0.1 : 0.05,
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .shimmer(duration: const Duration(seconds: 3)),
                  ),
                ],
              ),
            ),
          ),

          // ── Tactical Search & Intelligence ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionLabel(
                        "OPERATIONAL UNITS",
                        primaryColor,
                        textColor,
                      ),
                      Obx(
                        () => Text(
                          "${controller.contacts.length} ACTIVE",
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? cardColor
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.05),
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) => controller.updateSearch(val),
                      style: GoogleFonts.outfit(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Identify sentinel via name/ID...",
                        hintStyle: GoogleFonts.outfit(
                          color: textColor.withValues(alpha: 0.3),
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Remix.search_eye_line,
                          color: primaryColor,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Remix.drag_move_2_fill,
                        size: 10,
                        color: textColor.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "PRIORITY SEQUENCE OVERRIDE ENABLED",
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: textColor.withValues(alpha: 0.2),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Tactical Sentinel List ─────────────────────────────────────
          Obx(() {
            final contactsList = controller.filteredContacts;
            final isLoading =
                controller.isLoading.value || controller.isPhoneLoading.value;

            if (isLoading && contactsList.isEmpty) {
              return SliverFillRemaining(
                child: _buildEmptyStateLoader(primaryColor),
              );
            }

            if (contactsList.isEmpty) {
              return SliverFillRemaining(
                child: _buildNoContactsFound(primaryColor, textColor),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverReorderableList(
                itemCount: contactsList.length,
                onReorder: (oldIndex, newIndex) =>
                    controller.reorderSentinels(oldIndex, newIndex),
                itemBuilder: (context, index) {
                  return _buildReorderableContactCard(
                    contactsList[index],
                    primaryColor,
                    textColor,
                    cardColor,
                    isDark,
                    index,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color primary, Color textColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(color: primary.withValues(alpha: 0.5), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: textColor.withValues(alpha: 0.4),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateLoader(Color primary) {
    return Center(
      child: CircularProgressIndicator(color: primary, strokeWidth: 2),
    );
  }

  Widget _buildNoContactsFound(Color primary, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Remix.user_search_line,
          size: 80,
          color: primary.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
        Text(
          "NO SENTINELS DETECTED",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: textColor.withValues(alpha: 0.2),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildReorderableContactCard(
    Contact contact,
    Color primaryColor,
    Color textColor,
    Color cardColor,
    bool isDark,
    int index,
  ) {
    final keyString = contact.id == -1
        ? "phone_${contact.phoneNo}_${contact.name}"
        : "id_${contact.id}";
    return ReorderableDelayedDragStartListener(
      key: ValueKey(keyString),
      index: index,
      child: _buildContactCard(
        contact,
        primaryColor,
        textColor,
        cardColor,
        isDark,
        index,
      ),
    );
  }

  Widget _buildContactCard(
    Contact contact,
    Color primaryColor,
    Color textColor,
    Color cardColor,
    bool isDark,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? cardColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: contact.isNotifyOnSos
                ? primaryColor.withValues(alpha: 0.2)
                : textColor.withValues(alpha: 0.05),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (contact.id != -1) {
                Get.toNamed(
                  AppRoutes.addContact,
                  arguments: {'isEdit': true, 'contact': contact},
                );
              }
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildAvatar(contact, primaryColor, textColor, isDark, index),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name ?? "UNKNOWN UNIT",
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                contact.id == -1
                                    ? "LOCAL"
                                    : "PRIORITY ${index + 1}",
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            if (contact.isNotifyOnSos && contact.id != -1) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withValues(
                                    alpha: isDark ? 0.1 : 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "SOS ACTIVE",
                                  style: GoogleFonts.outfit(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: isDark
                                        ? Colors.greenAccent
                                        : const Color(0xFF1B5E20),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (contact.id != -1)
                    Obx(() {
                      // Safe check to prevent 'Bad state: No element'
                      final contactInList = controller.contacts
                          .firstWhereOrNull((c) => c.id == contact.id);
                      if (contactInList == null) return const SizedBox.shrink();

                      return Switch(
                        value: contactInList.isNotifyOnSos,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          controller.toggleNotification(contact.id!);
                        },
                        activeThumbColor: primaryColor,
                      );
                    }),
                  if (contact.id == -1)
                    TextButton(
                      onPressed: () => _inviteContact(contact),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          "INVITE",
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(contact),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Remix.delete_bin_line,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  void _inviteContact(Contact contact) {
    Get.snackbar(
      "TACTICAL ALERT",
      "SENTINEL ${contact.name} HAS BEEN NOTIFIED.",
      backgroundColor: Theme.of(context).cardColor,
      colorText: Theme.of(context).textTheme.bodyLarge?.color,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Remix.send_plane_fill, color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildAvatar(
    Contact contact,
    Color primary,
    Color textColor,
    bool isDark,
    int index,
  ) {
    final initials = contact.name?.substring(0, 1).toUpperCase() ?? "S";
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: contact.isNotifyOnSos
            ? primary
            : textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: contact.isNotifyOnSos
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: contact.isNotifyOnSos
              ? Colors.white
              : textColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Contact contact) async {
    final theme = Theme.of(context);
    final result = await Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              const Icon(
                Remix.error_warning_fill,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 24),
              Text(
                "DECOMMISSION SENTINEL?",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.titleLarge?.color,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to terminate ${contact.name}'s status as an emergency contact? They will no longer receive emergency alerts.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: theme.hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text(
                        "RETAIN",
                        style: GoogleFonts.outfit(
                          color: theme.hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "DECOMMISSION",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true && contact.id != -1) {
      final success = await controller.deleteContact(contact.id!);
      if (success) {
        Get.snackbar(
          "Status Updated",
          "Sentinel decommissioned successfully.",
          backgroundColor: theme.cardColor,
          colorText: theme.textTheme.bodyLarge?.color,
        );
      }
    }
  }
}

extension ColorsExt on Color {
  static const darkGreen = Color(0xFF1B5E20);
}

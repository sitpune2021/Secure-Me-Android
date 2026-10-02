// import 'dart:convert';
// import 'dart:developer' as dev;
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:secure_me/const/app_url.dart';
// import 'package:fast_contacts/fast_contacts.dart' as fast;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:secure_me/model/contact_model.dart';
// import 'package:secure_me/app/routes/app_pages.dart';
// import 'package:secure_me/core/utils/preference_helper.dart';

// class ContactController extends GetxController {
//   var isLoading = false.obs;
//   var contacts = <Contact>[].obs;
//   var phoneContacts = <Contact>[].obs;
//   var searchQuery = "".obs;
//   var currentPage = 1.obs;
//   var hasMore = true.obs;
//   var isPhoneLoading = false.obs;

//   // Tactical Priority & Notification Logic
//   var isSyncing = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchContacts();
//     fetchPhoneContacts();
//   }

//   Future<void> fetchContacts({bool loadMore = false}) async {
//     if (isLoading.value) return;
//     if (loadMore && !hasMore.value) return;

//     int pageToFetch = loadMore ? currentPage.value : 1;

//     isLoading.value = true;
//     dev.log(
//       '🔄 Fetching contacts (Page: $pageToFetch)...',
//       name: 'ContactController',
//     );

//     try {
//       String? token = await PreferenceHelper.getToken();

//       if (token == null || token.isEmpty) {
//         dev.log(
//           '❌ No token found, cannot fetch contacts.',
//           name: 'ContactController',
//         );
//         isLoading.value = false;
//         return;
//       }

//       final response = await http
//           .get(
//             Uri.parse("${AppUrl.contacts}?page=$pageToFetch"),
//             headers: {
//               'Accept': 'application/json',
//               'Authorization': 'Bearer ${token.trim()}',
//             },
//           )
//           .timeout(const Duration(seconds: 15));

//       dev.log(
//         '📡 Contacts Response Status: ${response.statusCode}',
//         name: 'ContactController',
//       );

//       if (response.statusCode == 401) {
//         await PreferenceHelper.clearUserData();
//         Get.offAllNamed(AppRoutes.loginView);
//         isLoading.value = false;
//         return;
//       }

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['status'] == true) {
//         ContactResponse contactRes = ContactResponse.fromJson(data);

//         if (!loadMore) {
//           // Fresh refresh (e.g. tab switch): only replace the old list
//           // once the new data has actually arrived — no blank/loader flash.
//           currentPage.value = 1;
//           hasMore.value = true;
//           contacts.value = contactRes.data ?? [];
//         } else {
//           // Pagination: append.
//           if (contactRes.data != null) {
//             contacts.addAll(contactRes.data!);
//           }
//         }

//         if (contactRes.pagination != null) {
//           hasMore.value = contactRes.pagination!.hasMore ?? false;
//           if (hasMore.value) {
//             currentPage.value = pageToFetch + 1;
//           }
//         } else {
//           hasMore.value = false;
//         }

//         dev.log(
//           '✅ Contacts loaded: ${contacts.length}',
//           name: 'ContactController',
//         );
//       } else {
//         dev.log(
//           '❌ Failed to retrieve contacts: ${data['message']}',
//           name: 'ContactController',
//         );
//       }
//     } catch (e) {
//       dev.log('❌ Error fetching contacts: $e', name: 'ContactController');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> deleteContact(int id) async {
//     dev.log('🟡 [deleteContact] START — id=$id', name: 'ContactController');
//     try {
//       dev.log(
//         '🟡 [deleteContact] Step 1: Getting token...',
//         name: 'ContactController',
//       );
//       String? token = await PreferenceHelper.getToken();

//       if (token == null || token.isEmpty) {
//         dev.log(
//           '🔴 [deleteContact] Step 1 FAILED — token is null/empty',
//           name: 'ContactController',
//         );
//         return false;
//       }
//       dev.log(
//         '🟢 [deleteContact] Step 1 OK — token found (len=${token.length})',
//         name: 'ContactController',
//       );

//       final url = "${AppUrl.deleteContact}/$id";
//       dev.log(
//         '🟡 [deleteContact] Step 2: Calling GET $url',
//         name: 'ContactController',
//       );

//       final response = await http
//           .delete(
//             // Most Laravel basic endpoints use GET for delete action with specific routes
//             Uri.parse(url),
//             headers: {
//               'Accept': 'application/json',
//               'Authorization': 'Bearer ${token.trim()}',
//             },
//           )
//           .timeout(const Duration(seconds: 15));

//       dev.log(
//         '🟢 [deleteContact] Step 2 OK — statusCode=${response.statusCode}',
//         name: 'ContactController',
//       );
//       dev.log(
//         '🟡 [deleteContact] Raw response body: ${response.body}',
//         name: 'ContactController',
//       );

//       if (response.statusCode == 401) {
//         dev.log(
//           '🔴 [deleteContact] Step 3 FAILED — 401 Unauthorized, clearing session',
//           name: 'ContactController',
//         );
//         await PreferenceHelper.clearUserData();
//         Get.offAllNamed(AppRoutes.loginView);
//         return false;
//       }

//       dev.log(
//         '🟡 [deleteContact] Step 4: Parsing JSON...',
//         name: 'ContactController',
//       );
//       final data = jsonDecode(response.body);
//       dev.log(
//         '🟢 [deleteContact] Step 4 OK — parsed data=$data',
//         name: 'ContactController',
//       );

//       if (response.statusCode == 200 && data['status'] == true) {
//         dev.log(
//           '🟢 [deleteContact] Step 5: API confirmed deletion — removing id=$id from local list',
//           name: 'ContactController',
//         );
//         final existed = contacts.any((c) => c.id == id);
//         dev.log(
//           '🟡 [deleteContact] Contact with id=$id present in local list before removal: $existed',
//           name: 'ContactController',
//         );

//         contacts.removeWhere((c) => c.id == id);

//         dev.log(
//           '🟢 [deleteContact] Step 5 OK — local list count now: ${contacts.length}',
//           name: 'ContactController',
//         );
//         dev.log('🟢 [deleteContact] SUCCESS', name: 'ContactController');
//         return true;
//       } else {
//         dev.log(
//           '🔴 [deleteContact] Step 5 FAILED — statusCode=${response.statusCode}, data[status]=${data['status']}, message=${data['message']}',
//           name: 'ContactController',
//         );
//       }
//     } catch (e, stack) {
//       dev.log('🔴 [deleteContact] EXCEPTION: $e', name: 'ContactController');
//       dev.log(
//         '🔴 [deleteContact] STACK TRACE: $stack',
//         name: 'ContactController',
//       );
//     }
//     dev.log(
//       '🔴 [deleteContact] END — returning false',
//       name: 'ContactController',
//     );
//     return false;
//   }

//   // Future<bool> deleteContact(int id) async {
//   //   try {
//   //     String? token = await PreferenceHelper.getToken();
//   //     if (token == null || token.isEmpty) return false;

//   //     final response = await http
//   //         .get(
//   //           // Most Laravel basic endpoints use GET for delete action with specific routes
//   //           Uri.parse("${AppUrl.deleteContact}/$id"),
//   //           headers: {
//   //             'Accept': 'application/json',
//   //             'Authorization': 'Bearer ${token.trim()}',
//   //           },
//   //         )
//   //         .timeout(const Duration(seconds: 15));

//   //     dev.log('📡 Delete Contact Status: ${response.statusCode}');

//   //     if (response.statusCode == 401) {
//   //       await PreferenceHelper.clearUserData();
//   //       Get.offAllNamed(AppRoutes.loginView);
//   //       return false;
//   //     }

//   //     final data = jsonDecode(response.body);
//   //     if (response.statusCode == 200 && data['status'] == true) {
//   //       contacts.removeWhere((c) => c.id == id);
//   //       return true;
//   //     }
//   //   } catch (e) {
//   //     dev.log('❌ Error deleting contact: $e', name: 'ContactController');
//   //   }
//   //   return false;
//   // }

//   Future<void> fetchPhoneContacts() async {
//     if (isPhoneLoading.value) return;
//     isPhoneLoading.value = true;
//     dev.log('🔄 Requesting contacts permission...', name: 'ContactController');

//     try {
//       if (await Permission.contacts.request().isGranted) {
//         dev.log(
//           '✅ Contacts permission granted. Fetching...',
//           name: 'ContactController',
//         );
//         final localContacts = await fast.FastContacts.getAllContacts();

//         final updated = localContacts.map((c) {
//           String? phone = c.phones.isNotEmpty
//               ? c.phones.first.number
//               : "No number";

//           return Contact(
//             id: -1,
//             name: c.displayName,
//             phoneNo: phone,
//             userRole: "Emergency Contact",
//           );
//         }).toList();

//         // Swap in one shot only once the new data is ready — old list
//         // stays visible on screen during the fetch, no flicker.
//         phoneContacts.value = updated;

//         dev.log(
//           '✅ Phone contacts loaded: ${phoneContacts.length}',
//           name: 'ContactController',
//         );
//       } else {
//         dev.log('⚠️ Contacts permission denied.', name: 'ContactController');
//       }
//     } catch (e) {
//       dev.log('❌ Error fetching phone contacts: $e', name: 'ContactController');
//     } finally {
//       isPhoneLoading.value = false;
//     }
//   }

//   // List<Contact> get filteredContacts {
//   //   List<Contact> all = [...contacts, ...phoneContacts];
//   //   if (searchQuery.isEmpty) {
//   //     return all;
//   //   }
//   //   String query = searchQuery.value.toLowerCase();
//   //   return all
//   //       .where(
//   //         (c) =>
//   //             (c.name != null && c.name!.toLowerCase().contains(query)) ||
//   //             (c.phoneNo != null && c.phoneNo!.contains(query)),
//   //       )
//   //       .toList();
//   // }

//   // dynamic
//   List<Contact> get filteredApiContacts {
//     if (searchQuery.isEmpty) return contacts;
//     String query = searchQuery.value.toLowerCase();
//     return contacts
//         .where(
//           (c) =>
//               (c.name != null && c.name!.toLowerCase().contains(query)) ||
//               (c.phoneNo != null && c.phoneNo!.contains(query)),
//         )
//         .toList();
//   }

//   // local
//   List<Contact> get filteredLocalContacts {
//     if (searchQuery.isEmpty) return phoneContacts;
//     String query = searchQuery.value.toLowerCase();
//     return phoneContacts
//         .where(
//           (c) =>
//               (c.name != null && c.name!.toLowerCase().contains(query)) ||
//               (c.phoneNo != null && c.phoneNo!.contains(query)),
//         )
//         .toList();
//   }

//   void updateSearch(String query) {
//     searchQuery.value = query;
//   }

//   // ── Tactical Sentinel Management ──────────────────────────────

//   Future<void> updatePriority(int contactId, int newPriority) async {
//     final index = contacts.indexWhere((c) => c.id == contactId);
//     if (index != -1) {
//       contacts[index] = contacts[index].copyWith(priority: newPriority);
//       contacts.sort((a, b) => a.priority.compareTo(b.priority));
//       // In a real app, send to API here
//       dev.log(
//         "✅ Sentinel priority updated for ID: $contactId to $newPriority",
//         name: "ContactController",
//       );
//     }
//   }

//   Future<void> toggleNotification(int contactId) async {
//     final index = contacts.indexWhere((c) => c.id == contactId);
//     if (index != -1) {
//       contacts[index] = contacts[index].copyWith(
//         isNotifyOnSos: !contacts[index].isNotifyOnSos,
//       );
//       dev.log(
//         "✅ Notification status toggled for ID: $contactId",
//         name: "ContactController",
//       );
//     }
//   }

//   Future<void> reorderSentinels(int oldIndex, int newIndex) async {
//     if (newIndex > oldIndex) newIndex--;
//     final item = contacts.removeAt(oldIndex);
//     contacts.insert(newIndex, item);

//     // Update priorities based on new list position
//     for (int i = 0; i < contacts.length; i++) {
//       contacts[i] = contacts[i].copyWith(priority: i + 1);
//     }
//     dev.log(
//       "✅ Sentinels reordered and priorities synced.",
//       name: "ContactController",
//     );
//   }
// }
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:fast_contacts/fast_contacts.dart' as fast;
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_me/model/contact_model.dart';
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:secure_me/core/utils/preference_helper.dart';

/// Carries both the success flag and the actual message returned
/// by the API (or a sensible fallback), so the UI can show the
/// real response instead of a hardcoded string.
class DeleteContactResult {
  final bool success;
  final String message;
  DeleteContactResult({required this.success, required this.message});
}

class ContactController extends GetxController {
  var isLoading = false.obs;
  var contacts = <Contact>[].obs;
  var phoneContacts = <Contact>[].obs;
  var searchQuery = "".obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  var isPhoneLoading = false.obs;

  // Tactical Priority & Notification Logic
  var isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
    fetchPhoneContacts();
  }

  Future<void> fetchContacts({bool loadMore = false}) async {
    if (isLoading.value) return;
    if (loadMore && !hasMore.value) return;

    int pageToFetch = loadMore ? currentPage.value : 1;

    isLoading.value = true;
    dev.log(
      '🔄 Fetching contacts (Page: $pageToFetch)...',
      name: 'ContactController',
    );

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot fetch contacts.',
          name: 'ContactController',
        );
        isLoading.value = false;
        return;
      }

      final response = await http
          .get(
            Uri.parse("${AppUrl.contacts}?page=$pageToFetch"),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
          )
          .timeout(const Duration(seconds: 15));

      dev.log(
        '📡 Contacts Response Status: ${response.statusCode}',
        name: 'ContactController',
      );

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        isLoading.value = false;
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        ContactResponse contactRes = ContactResponse.fromJson(data);

        if (!loadMore) {
          // Fresh refresh (e.g. tab switch): only replace the old list
          // once the new data has actually arrived — no blank/loader flash.
          currentPage.value = 1;
          hasMore.value = true;
          contacts.value = contactRes.data ?? [];
        } else {
          // Pagination: append.
          if (contactRes.data != null) {
            contacts.addAll(contactRes.data!);
          }
        }

        if (contactRes.pagination != null) {
          hasMore.value = contactRes.pagination!.hasMore ?? false;
          if (hasMore.value) {
            currentPage.value = pageToFetch + 1;
          }
        } else {
          hasMore.value = false;
        }

        dev.log(
          '✅ Contacts loaded: ${contacts.length}',
          name: 'ContactController',
        );
      } else {
        dev.log(
          '❌ Failed to retrieve contacts: ${data['message']}',
          name: 'ContactController',
        );
      }
    } catch (e) {
      dev.log('❌ Error fetching contacts: $e', name: 'ContactController');
    } finally {
      isLoading.value = false;
    }
  }

  Future<DeleteContactResult> deleteContact(int id) async {
    dev.log('🟡 [deleteContact] START — id=$id', name: 'ContactController');
    try {
      dev.log(
        '🟡 [deleteContact] Step 1: Getting token...',
        name: 'ContactController',
      );
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '🔴 [deleteContact] Step 1 FAILED — token is null/empty',
          name: 'ContactController',
        );
        return DeleteContactResult(
          success: false,
          message: "Authentication token is missing.",
        );
      }
      dev.log(
        '🟢 [deleteContact] Step 1 OK — token found (len=${token.length})',
        name: 'ContactController',
      );

      final url = "${AppUrl.deleteContact}/$id";
      dev.log(
        '🟡 [deleteContact] Step 2: Calling DELETE $url',
        name: 'ContactController',
      );

      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
          )
          .timeout(const Duration(seconds: 15));

      dev.log(
        '🟢 [deleteContact] Step 2 OK — statusCode=${response.statusCode}',
        name: 'ContactController',
      );
      dev.log(
        '🟡 [deleteContact] Raw response body: ${response.body}',
        name: 'ContactController',
      );

      if (response.statusCode == 401) {
        dev.log(
          '🔴 [deleteContact] Step 3 FAILED — 401 Unauthorized, clearing session',
          name: 'ContactController',
        );
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return DeleteContactResult(
          success: false,
          message: "Session expired. Please log in again.",
        );
      }

      dev.log(
        '🟡 [deleteContact] Step 4: Parsing JSON...',
        name: 'ContactController',
      );
      final data = jsonDecode(response.body);
      dev.log(
        '🟢 [deleteContact] Step 4 OK — parsed data=$data',
        name: 'ContactController',
      );

      final apiMessage = data['message']?.toString();

      if (response.statusCode == 200 && data['status'] == true) {
        dev.log(
          '🟢 [deleteContact] Step 5: API confirmed deletion — removing id=$id from local list',
          name: 'ContactController',
        );
        final existed = contacts.any((c) => c.id == id);
        dev.log(
          '🟡 [deleteContact] Contact with id=$id present in local list before removal: $existed',
          name: 'ContactController',
        );

        contacts.removeWhere((c) => c.id == id);

        dev.log(
          '🟢 [deleteContact] Step 5 OK — local list count now: ${contacts.length}',
          name: 'ContactController',
        );
        dev.log('🟢 [deleteContact] SUCCESS', name: 'ContactController');
        return DeleteContactResult(
          success: true,
          message: apiMessage ?? "Sentinel decommissioned successfully.",
        );
      } else {
        dev.log(
          '🔴 [deleteContact] Step 5 FAILED — statusCode=${response.statusCode}, data[status]=${data['status']}, message=$apiMessage',
          name: 'ContactController',
        );
        return DeleteContactResult(
          success: false,
          message: apiMessage ?? "Failed to delete contact.",
        );
      }
    } catch (e, stack) {
      dev.log('🔴 [deleteContact] EXCEPTION: $e', name: 'ContactController');
      dev.log(
        '🔴 [deleteContact] STACK TRACE: $stack',
        name: 'ContactController',
      );
      return DeleteContactResult(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  Future<void> fetchPhoneContacts() async {
    if (isPhoneLoading.value) return;
    isPhoneLoading.value = true;
    dev.log('🔄 Requesting contacts permission...', name: 'ContactController');

    try {
      if (await Permission.contacts.request().isGranted) {
        dev.log(
          '✅ Contacts permission granted. Fetching...',
          name: 'ContactController',
        );
        final localContacts = await fast.FastContacts.getAllContacts();

        final updated = localContacts.map((c) {
          String? phone = c.phones.isNotEmpty
              ? c.phones.first.number
              : "No number";

          return Contact(
            id: -1,
            name: c.displayName,
            phoneNo: phone,
            userRole: "Emergency Contact",
          );
        }).toList();

        // Swap in one shot only once the new data is ready — old list
        // stays visible on screen during the fetch, no flicker.
        phoneContacts.value = updated;

        dev.log(
          '✅ Phone contacts loaded: ${phoneContacts.length}',
          name: 'ContactController',
        );
      } else {
        dev.log('⚠️ Contacts permission denied.', name: 'ContactController');
      }
    } catch (e) {
      dev.log('❌ Error fetching phone contacts: $e', name: 'ContactController');
    } finally {
      isPhoneLoading.value = false;
    }
  }

  // dynamic
  List<Contact> get filteredApiContacts {
    if (searchQuery.isEmpty) return contacts;
    String query = searchQuery.value.toLowerCase();
    return contacts
        .where(
          (c) =>
              (c.name != null && c.name!.toLowerCase().contains(query)) ||
              (c.phoneNo != null && c.phoneNo!.contains(query)),
        )
        .toList();
  }

  // local
  List<Contact> get filteredLocalContacts {
    if (searchQuery.isEmpty) return phoneContacts;
    String query = searchQuery.value.toLowerCase();
    return phoneContacts
        .where(
          (c) =>
              (c.name != null && c.name!.toLowerCase().contains(query)) ||
              (c.phoneNo != null && c.phoneNo!.contains(query)),
        )
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  // ── Tactical Sentinel Management ──────────────────────────────

  Future<void> updatePriority(int contactId, int newPriority) async {
    final index = contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(priority: newPriority);
      contacts.sort((a, b) => a.priority.compareTo(b.priority));
      // In a real app, send to API here
      dev.log(
        "✅ Sentinel priority updated for ID: $contactId to $newPriority",
        name: "ContactController",
      );
    }
  }

  Future<void> toggleNotification(int contactId) async {
    final index = contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(
        isNotifyOnSos: !contacts[index].isNotifyOnSos,
      );
      dev.log(
        "✅ Notification status toggled for ID: $contactId",
        name: "ContactController",
      );
    }
  }

  Future<void> reorderSentinels(int oldIndex, int newIndex) async {
    // NOTE: onReorderItem (the non-deprecated callback) already adjusts
    // newIndex for the removed item, so do NOT decrement it manually here
    // — that adjustment was only correct for the old deprecated onReorder.
    final item = contacts.removeAt(oldIndex);
    contacts.insert(newIndex, item);

    // Update priorities based on new list position
    for (int i = 0; i < contacts.length; i++) {
      contacts[i] = contacts[i].copyWith(priority: i + 1);
    }
    dev.log(
      "✅ Sentinels reordered and priorities synced.",
      name: "ContactController",
    );
  }
}

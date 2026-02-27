import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:fast_contacts/fast_contacts.dart' as fast;
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_me/model/contact_model.dart';
import 'package:secure_me/utils/preference_helper.dart';

class ContactController extends GetxController {
  var isLoading = false.obs;
  var contacts = <Contact>[].obs;
  var phoneContacts = <Contact>[].obs;
  var searchQuery = "".obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  var isPhoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
    fetchPhoneContacts();
  }

  Future<void> fetchContacts({bool loadMore = false}) async {
    if (isLoading.value) return;
    if (loadMore && !hasMore.value) return;

    if (!loadMore) {
      currentPage.value = 1;
      contacts.clear();
      hasMore.value = true;
    }

    isLoading.value = true;
    dev.log(
      '🔄 Fetching contacts (Page: ${currentPage.value})...',
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

      final response = await http.get(
        Uri.parse("${AppUrl.contacts}?page=${currentPage.value}"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      dev.log(
        '📡 Contacts Response Status: ${response.statusCode}',
        name: 'ContactController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        ContactResponse contactRes = ContactResponse.fromJson(data);
        if (contactRes.data != null) {
          contacts.addAll(contactRes.data!);
        }

        if (contactRes.pagination != null) {
          hasMore.value = contactRes.pagination!.hasMore ?? false;
          if (hasMore.value) {
            currentPage.value++;
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

  Future<void> fetchPhoneContacts() async {
    isPhoneLoading.value = true;
    dev.log('🔄 Requesting contacts permission...', name: 'ContactController');

    try {
      if (await Permission.contacts.request().isGranted) {
        dev.log(
          '✅ Contacts permission granted. Fetching...',
          name: 'ContactController',
        );
        final localContacts = await fast.FastContacts.getAllContacts();

        phoneContacts.value = localContacts.map((c) {
          // Normalize phone number (take first if multiple)
          String? phone = c.phones.isNotEmpty
              ? c.phones.first.number
              : "No number";

          return Contact(
            id: -1, // Distinguish from API contacts
            name: c.displayName,
            phoneNo: phone,
            userRole: "Phone Contact",
          );
        }).toList();

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

  List<Contact> get filteredContacts {
    List<Contact> all = [...contacts, ...phoneContacts];
    if (searchQuery.isEmpty) {
      return all;
    }
    String query = searchQuery.value.toLowerCase();
    return all
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
}

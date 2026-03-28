import 'package:get/get.dart';
import 'package:secure_me/model/contact_model.dart';
import 'dart:developer' as dev;

class EmergencyContactController extends GetxController {
  final RxList<Contact> contacts = <Contact>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-load mock contacts
    contacts.addAll([
      Contact(name: "Dad", phoneNo: "+1 234 567 8901", priority: 1, isNotifyOnSos: true),
      Contact(name: "Mom", phoneNo: "+1 234 567 8902", priority: 2, isNotifyOnSos: true),
      Contact(name: "Best Friend", phoneNo: "+1 234 567 8903", priority: 3, isNotifyOnSos: true),
    ]);
  }

  void addContact(Contact contact) {
    contacts.add(contact);
    _reorderContacts();
  }

  void removeContact(String phoneNo) {
    contacts.removeWhere((c) => c.phoneNo == phoneNo);
    _reorderContacts();
  }

  void updatePriority(String phoneNo, int newPriority) {
    final index = contacts.indexWhere((c) => c.phoneNo == phoneNo);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(priority: newPriority);
      _reorderContacts();
    }
  }

  void toggleNotification(String phoneNo) {
    final index = contacts.indexWhere((c) => c.phoneNo == phoneNo);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(
        isNotifyOnSos: !contacts[index].isNotifyOnSos
      );
    }
  }

  void _reorderContacts() {
    contacts.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void notifyContacts(String trackingLink) {
    for (var contact in contacts) {
      if (contact.isNotifyOnSos) {
        // Here we would use an SMS plugin or backend API
        dev.log("🚨 SMS Alert Sent to ${contact.name}: My emergency location is $trackingLink", name: 'ContactController');
      }
    }
  }
}

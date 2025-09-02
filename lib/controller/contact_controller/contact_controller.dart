import 'package:get/get.dart';

class ContactController extends GetxController {
  var contacts = <String>[
    "Akash",
    "Ajay",
    "Anushree",
    "Anuja",
    "Baban",
    "Bina",
    "Charuta",
    "Chinki",
    "Chanda",
    "Chandrakant",
    "Daivi",
    "Deepa",
    "Dhiraj",
    "Dhanjay",
    "Dhiru",
    "Faiz",
    "Imali",
    "Kamla"
  ].obs;

  var searchQuery = "".obs;

  List<String> get filteredContacts {
    if (searchQuery.isEmpty) {
      return contacts;
    }
    return contacts
        .where((c) => c.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}

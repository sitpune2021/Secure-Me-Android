import 'package:get/get.dart';

class AddFriendsController extends GetxController {
  var friends = <Map<String, String>>[].obs;
  var filteredFriends = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  void loadFriends() {
    friends.value = [
      {
        "name": "Oliver Smith",
        "phone": "+9112345678",
        "image": "assets/images/f1.png",
      },
      {
        "name": "Shilpa Sharma",
        "phone": "+9198765432",
        "image": "assets/images/f2.png",
      },
      {
        "name": "Gaurav Pawar",
        "phone": "+9188888888",
        "image": "assets/images/f3.png",
      },
      {
        "name": "Ankita Punekar",
        "phone": "+9177777777",
        "image": "assets/images/f4.png",
      },
      {
        "name": "Nikita Nanaware",
        "phone": "+9166666666",
        "image": "assets/images/f5.png",
      },
      {
        "name": "Rupa Deshmukh",
        "phone": "+9155555555",
        "image": "assets/images/f6.png",
      },
      {
        "name": "Karina Mandhare",
        "phone": "+9144444444",
        "image": "assets/images/f7.png",
      },
      {
        "name": "Lina Patil",
        "phone": "+9133333333",
        "image": "assets/images/f8.png",
      },
    ];
    filteredFriends.assignAll(friends);
  }

  void searchFriends(String query) {
    if (query.isEmpty) {
      filteredFriends.assignAll(friends);
    } else {
      filteredFriends.assignAll(
        friends.where(
          (friend) =>
              friend["name"]!.toLowerCase().contains(query.toLowerCase()) ||
              friend["phone"]!.contains(query),
        ),
      );
    }
  }
}

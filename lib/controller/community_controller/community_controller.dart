import 'package:get/get.dart';
import 'package:secure_me/model/community_model.dart';

class CommunityController extends GetxController {
  var communities = <CommunityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCommunities();
  }

  void loadCommunities() {
    communities.value = [
      CommunityModel(name: "Emergency Helping Group", members: "10 K members"),
      CommunityModel(name: "Be Women Society", members: "10 K members"),
      CommunityModel(name: "Family Members", members: "50 members"),
      CommunityModel(name: "My Friends", members: "100 Members"),
      CommunityModel(name: "League Lady Power", members: "1k Members"),
      CommunityModel(name: "World Of Angels", members: "2k Members"),
    ];
  }
}

import 'package:get/get.dart';

class TrackMeController extends GetxController {
  var selectedTransport = 0.obs;

  void selectTransport(int index) {
    selectedTransport.value = index;
  }
}

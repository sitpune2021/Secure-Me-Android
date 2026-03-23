import 'package:get/get.dart';
import 'package:secure_me/model/user_model.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;


  void login(String email, String password, UserRole role) async {
    isLoading.value = true;
    
    // Mock Login delay
    await Future.delayed(const Duration(seconds: 1));
    
    user.value = UserModel(
      id: '1',
      name: 'Mock ${role.name.toUpperCase()}',
      email: email,
      phone: '1234567890',
      role: role,
    );
    
    isLoading.value = false;
    
    // Navigation handled by the router/view depending on state
  }

  void logout() {
    user.value = null;
  }
}

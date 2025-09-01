import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/view/home_view/home_view.dart';
import 'package:secure_me/view/login_view/login_view.dart';
import 'package:secure_me/view/notification_view/notification_view.dart';
import 'package:secure_me/view/otp_view/otp_view.dart';
import 'package:secure_me/view/profile_view/profile_view.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.loginView, page: () => LoginView()),
    GetPage(name: AppRoutes.otpView, page: () => OtpView()),
    GetPage(name: AppRoutes.homeView, page: () => HomeView()),
    GetPage(name: AppRoutes.notification, page: () => NotificationView()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView()),
    // GetPage(name: AppRoutes.setting, page: () => const SettingView()),
    // GetPage(name: AppRoutes.friends, page: () => const FriendsView()),
    // GetPage(name: AppRoutes.help, page: () => const HelpView()),
    // GetPage(name: AppRoutes.appInfo, page: () => const AppInfoView()),
    // GetPage(name: AppRoutes.feedback, page: () => const FeedbackView()),
  ];
}

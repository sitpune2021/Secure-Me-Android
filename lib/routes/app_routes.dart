import 'dart:math';

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/view/add_contact_view/add_contact_view.dart';
import 'package:secure_me/view/add_friend_view/add_friend_view.dart';
import 'package:secure_me/view/contact_list_view/contact_list_view.dart';
import 'package:secure_me/view/edit_profile_view/edit_profile_view.dart';
import 'package:secure_me/view/fake_call_view/fake_call_view.dart';
import 'package:secure_me/view/home_view/home_view.dart';
import 'package:secure_me/view/location_view/location_view.dart';
import 'package:secure_me/view/login_view/login_view.dart';
import 'package:secure_me/view/notification_view/notification_view.dart';
import 'package:secure_me/view/otp_view/otp_view.dart';
import 'package:secure_me/view/profile_view/profile_view.dart';
import 'package:secure_me/view/push_notification_view/push_notification_view.dart';
import 'package:secure_me/view/register_view.dart/register_view.dart';
import 'package:secure_me/view/setting_view/setting_view.dart';
import 'package:secure_me/view/share_location_view/share_location_view.dart';
import 'package:secure_me/view/sos_active_view/sos_active_view.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.loginView, page: () => LoginView()),
    GetPage(name: AppRoutes.otpView, page: () => OtpView()),
    GetPage(name: AppRoutes.homeView, page: () => HomeView()),
    GetPage(name: AppRoutes.notification, page: () => NotificationView()),
    GetPage(name: AppRoutes.profile, page: () => ProfileView()),
    GetPage(name: AppRoutes.setting, page: () => SettingsView()),
    GetPage(name: AppRoutes.friends, page: () => const AddFriendsView()),
    GetPage(name: AppRoutes.editProfile, page: () => EditProfileView()),
    GetPage(name: AppRoutes.contactList, page: () => ContactListView()),
    GetPage(name: AppRoutes.addContact, page: () => AddContactView()),
    GetPage(name: AppRoutes.location, page: () => LocationView()),
    GetPage(
      name: AppRoutes.pushnotification,
      page: () => PushNotificationView(),
    ),
    GetPage(name: AppRoutes.fakecall, page: () => FakeCallView()),
    GetPage(name: AppRoutes.sosActivate, page: () => SosActivatedView()),
    GetPage(name: AppRoutes.registerView, page: () => RegisterView()),
    GetPage(name: AppRoutes.shareLiveLocation, page: () => ShareLocationView()),
    // GetPage(name: AppRoutes.help, page: () => const HelpView()),
    // GetPage(name: AppRoutes.appInfo, page: () => const AppInfoView()),
    // GetPage(name: AppRoutes.feedback, page: () => const FeedbackView()),
  ];
}

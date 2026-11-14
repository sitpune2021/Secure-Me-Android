class AppUrl {
  AppUrl._();

  // Base URLs
  static const String host = "https://secureme.thecanatech.com";
  static const String baseUrl = "$host/api";

  static const String register = "$baseUrl/auth/register"; // fix
  static const String login = "$baseUrl/auth/login"; // fix
  static const String sendOtp = "$baseUrl/auth/send-otp"; // fix
  static const String verifyOtp = "$baseUrl/auth/verify-otp"; // fix
  static const String resendOtp = "$baseUrl/auth/resend-otp"; // missing
  static const String logout = "$baseUrl/auth/logout"; // fix

  // User Profile
  static const String profile = "$baseUrl/auth/profile"; // fix
  static const String userRole = "$baseUrl/auth/user-role"; // fix
  static const String updateProfile = "$baseUrl/auth/update-profile"; // fix

  // Emergency Contacts
  static const String contacts = "$baseUrl/auth/contacts"; // fix
  static const String addContact = "$baseUrl/auth/add/contacts";
  static const String updateContact = "$baseUrl/update/contacts";
  static const String deleteContact = "$baseUrl/auth/delete/contacts"; // fix

  // Emergency Signal
  static const String signalTrigger = "$baseUrl/auth/signal/trigger"; // fix
  static const String updateLocation =
      "$baseUrl/auth/user/update-location"; //new
  static const String signalRespond = "$baseUrl/auth/signal/respond";

  // Community
  static const String communities = "$baseUrl/community";
  static const String createCommunity = "$baseUrl/community/create";
  static const String addCommunityContact = "$baseUrl/community/add-contacts";
}

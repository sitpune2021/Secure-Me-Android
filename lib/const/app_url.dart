class AppUrl {
  static const String host = "https://secureme.thecanatech.com";
  static const String storageUrl = "$host/storage";
  static const String baseUrl = "$host/api";

  static String buildImageUrl(String path) {
    if (path.isEmpty) return path;

    if (path.startsWith('http')) {

      if (path.contains('/storage/')) return path;

      final uri = Uri.tryParse(path);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        return '$storageUrl/${uri.pathSegments.last}';
      }
      return path;
    }

    if (path.startsWith('/storage/') || path.startsWith('storage/')) {
      return '$host/${path.replaceFirst(RegExp(r'^\/'), '')}';
    }

    return '$storageUrl/$path';
  }

  static const String register = "$baseUrl/auth/register";
  static const String login = "$baseUrl/auth/login";
  static const String sendOtp = "$baseUrl/auth/send-otp";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String resendOtp = "$baseUrl/auth/resend-otp";
  static const String logout = "$baseUrl/auth/logout";
  static const String profile = "$baseUrl/user/profile";
  static const String userRole = "$baseUrl/auth/user-role";
  static const String updateProfile = "$baseUrl/user/update/profile";
  static const String contacts = "$baseUrl/contacts";
  static const String addContact = "$baseUrl/add/contacts";
  static const String updateContact = "$baseUrl/update/contacts";
  static const String deleteContact = "$baseUrl/delete/contacts";
  static const String signalTrigger = "$baseUrl/signal/trigger";
  static const String signalRespond = "$baseUrl/signal/respond";
  static const String communities = "$baseUrl/community";
  static const String createCommunity = "$baseUrl/community/create";
  static const String addCommunityContact = "$baseUrl/community/add-contacts";
}

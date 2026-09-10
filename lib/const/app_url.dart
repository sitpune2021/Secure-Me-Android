class AppUrl {
  static const String host = "https://secureme.thecanatech.com";
  static const String storageUrl = "$host/storage";
  static const String baseUrl = "$host/api";

  static String buildImageUrl(String path) {
    if (path.isEmpty) return path;

    if (path.startsWith('http')) {
      // If the URL already contains /storage/ or is from the host and NOT a broken reference, return it
      if (path.contains('/storage/') || path.contains('/admin-assets/')) {
        return path;
      }

      // Handle cases where the server might return an absolute URL from another source/IP
      // that we want to unify to our current host
      if (!path.startsWith(host)) {
        final uri = Uri.tryParse(path);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          return '$storageUrl/${uri.pathSegments.last}';
        }
      }
      return path;
    }

    if (path.startsWith('/storage/') || path.startsWith('storage/')) {
      return '$host/${path.replaceFirst(RegExp(r'^\/'), '')}';
    }

    return '$storageUrl/$path';
  }

  static const String register = "$baseUrl/auth/register"; // fix
  static const String login = "$baseUrl/auth/login";  // fix 
  static const String sendOtp = "$baseUrl/auth/send-otp"; // fix
  static const String verifyOtp = "$baseUrl/auth/verify-otp"; // fix
  static const String resendOtp = "$baseUrl/auth/resend-otp"; // missing
  static const String logout = "$baseUrl/auth/logout"; // fix 

  static const String profile = "$baseUrl/auth/profile";  // fix 
  static const String userRole = "$baseUrl/auth/user-role"; // fix 
  static const String updateProfile = "$baseUrl/auth/update-profile"; // fix 

  static const String contacts = "$baseUrl/contacts";
  static const String addContact = "$baseUrl/add/contacts";
  static const String updateContact = "$baseUrl/update/contacts";
  static const String deleteContact = "$baseUrl/delete/contacts";

  static const String signalTrigger = "$baseUrl/signal/trigger";
  static const String updateLocation = "$baseUrl/auth/user/update-location";  //new
  static const String signalRespond = "$baseUrl/signal/respond";

  static const String communities = "$baseUrl/community";
  static const String createCommunity = "$baseUrl/community/create";
  static const String addCommunityContact = "$baseUrl/community/add-contacts";
}

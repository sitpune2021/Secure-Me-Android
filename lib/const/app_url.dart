class AppUrl {
  static const String host = "http://192.168.1.58:8000";
  static const String baseUrl = "$host/api";
  static const String register = "$baseUrl/auth/register";
  static const String login = "$baseUrl/auth/login";
  static const String sendOtp = "$baseUrl/auth/send-otp";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String resendOtp = "$baseUrl/auth/resend-otp";
  static const String logout = "$baseUrl/auth/logout";
  static const String profile = "$baseUrl/auth/profile";
}

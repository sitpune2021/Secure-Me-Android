import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    print('✅ Token saved to SharedPreferences: $token');
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    print('📖 Token retrieved from SharedPreferences: $token');
    return token;
  }

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    print('✅ User ID saved to SharedPreferences: $userId');
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    print('📖 User ID retrieved from SharedPreferences: $userId');
    return userId;
  }

  // Save user name
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    print('✅ User name saved to SharedPreferences: $name');
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
    print('✅ User email saved to SharedPreferences: $email');
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // Save user phone
  static Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPhone, phone);
    print('✅ User phone saved to SharedPreferences: $phone');
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  // Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    print('✅ Login status saved to SharedPreferences: $isLoggedIn');
  }

  // Get login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
    await prefs.setBool(_keyIsLoggedIn, false);
    print('🗑️ All user data cleared from SharedPreferences');
  }

  // Save all user data at once
  static Future<void> saveUserData({
    required String token,
    required String userId,
    String? name,
    String? email,
    String? phone,
  }) async {
    await saveToken(token);
    await saveUserId(userId);
    if (name != null) await saveUserName(name);
    if (email != null) await saveUserEmail(email);
    if (phone != null) await saveUserPhone(phone);
    await saveLoginStatus(true);
    print('✅ All user data saved successfully');
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserProfileImage = 'user_profile_image';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserCreatedAt = 'user_created_at';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keySessionId = 'session_id';
  static const String _keyLastLoginTime = 'last_login_time';
  static const String _keySessionStartTime = 'session_start_time';
  static const String _keyCommunities = 'local_communities';
  static const String _keyEmergencyPin = 'emergency_pin';

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    log('✅ Token saved to SharedPreferences: $token', name: 'PreferenceHelper');
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    log(
      '📖 Token retrieved from SharedPreferences: $token',
      name: 'PreferenceHelper',
    );
    return token;
  }

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    log(
      '✅ User ID saved to SharedPreferences: $userId',
      name: 'PreferenceHelper',
    );
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    log(
      '📖 User ID retrieved from SharedPreferences: $userId',
      name: 'PreferenceHelper',
    );
    return userId;
  }

  // Save user name
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    log(
      '✅ User name saved to SharedPreferences: $name',
      name: 'PreferenceHelper',
    );
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyUserName);
    log(
      '📖 User name retrieved from SharedPreferences: $name',
      name: 'PreferenceHelper',
    );
    return name;
  }

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
    log(
      '✅ User email saved to SharedPreferences: $email',
      name: 'PreferenceHelper',
    );
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
    log(
      '✅ User phone saved to SharedPreferences: $phone',
      name: 'PreferenceHelper',
    );
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(_keyUserPhone);
    log(
      '📖 User phone retrieved from SharedPreferences: $phone',
      name: 'PreferenceHelper',
    );
    return phone;
  }

  // Save user role
  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role);
    log(
      '✅ User role saved to SharedPreferences: $role',
      name: 'PreferenceHelper',
    );
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_keyUserRole);
    log(
      '📖 User role retrieved from SharedPreferences: $role',
      name: 'PreferenceHelper',
    );
    return role;
  }

  // Save user created at
  static Future<void> saveUserCreatedAt(String createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserCreatedAt, createdAt);
    log(
      '✅ User created at saved to SharedPreferences: $createdAt',
      name: 'PreferenceHelper',
    );
  }

  // Get user created at
  static Future<String?> getUserCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final createdAt = prefs.getString(_keyUserCreatedAt);
    log(
      '📖 User created at retrieved from SharedPreferences: $createdAt',
      name: 'PreferenceHelper',
    );
    return createdAt;
  }

  // Save profile image
  static Future<void> saveUserProfileImage(String? image) async {
    final prefs = await SharedPreferences.getInstance();
    if (image != null) {
      await prefs.setString(_keyUserProfileImage, image);
      log(
        '✅ Profile image saved to SharedPreferences: $image',
        name: 'PreferenceHelper',
      );
    } else {
      await prefs.remove(_keyUserProfileImage);
    }
  }

  // Get profile image
  static Future<String?> getUserProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserProfileImage);
  }

  // Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    log(
      '✅ Login status saved to SharedPreferences: $isLoggedIn',
      name: 'PreferenceHelper',
    );
  }

  // Get login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Alias for getLoginStatus
  static Future<bool> getLoginStatus() async {
    return isLoggedIn();
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    log(
      '🗑️ All user data cleared from SharedPreferences',
      name: 'PreferenceHelper',
    );
  }

  // Save all user data at once
  static Future<void> saveUserData({
    required String token,
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? userRole,
    String? userCreatedAt,
  }) async {
    await saveToken(token);
    await saveUserId(userId);
    if (name != null) await saveUserName(name);
    if (email != null) await saveUserEmail(email);
    if (phone != null) await saveUserPhone(phone);
    if (profileImage != null) await saveUserProfileImage(profileImage);
    if (userRole != null) await saveUserRole(userRole);
    if (userCreatedAt != null) await saveUserCreatedAt(userCreatedAt);
    await saveLoginStatus(true);
    await _createSession();
  }

  // Session Management
  static Future<void> _createSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentTime = DateTime.now().toIso8601String();

    await prefs.setString(_keySessionId, sessionId);
    await prefs.setString(_keyLastLoginTime, currentTime);
    await prefs.setString(_keySessionStartTime, currentTime);
  }

  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionId);
  }

  static Future<String?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastLoginTime);
  }

  static Future<String?> getSessionStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionStartTime);
  }

  static Future<void> updateLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().toIso8601String();
    await prefs.setString(_keyLastLoginTime, currentTime);
  }

  static Future<bool> isSessionValid() async {
    final lastLoginTime = await getLastLoginTime();
    if (lastLoginTime == null) return false;
    try {
      final lastLogin = DateTime.parse(lastLoginTime);
      final now = DateTime.now();
      return now.difference(lastLogin).inDays <= 30;
    } catch (e) {
      return false;
    }
  }

  // Community persistence
  static Future<void> saveCommunities(List<Map<String, dynamic>> communities) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = communities.map((c) => jsonEncode(c)).toList();
    await prefs.setStringList(_keyCommunities, encoded);
  }

  static Future<List<Map<String, dynamic>>> loadCommunities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyCommunities) ?? [];
    return raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  // Emergency PIN methods
  static Future<void> saveEmergencyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmergencyPin, pin);
    log('✅ Emergency PIN saved: $pin', name: 'PreferenceHelper');
  }

  static Future<String> getEmergencyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString(_keyEmergencyPin) ?? "1234";
    log('📖 Emergency PIN retrieved: $pin', name: 'PreferenceHelper');
    return pin;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keySessionId = 'session_id';
  static const String _keyLastLoginTime = 'last_login_time';
  static const String _keySessionStartTime = 'session_start_time';

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
    final name = prefs.getString(_keyUserName);
    print('📖 User name retrieved from SharedPreferences: $name');
    return name;
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
    final phone = prefs.getString(_keyUserPhone);
    print('📖 User phone retrieved from SharedPreferences: $phone');
    return phone;
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

  // Alias for getLoginStatus (for consistency)
  static Future<bool> getLoginStatus() async {
    return isLoggedIn();
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
    await clearSession();
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
    print('💾 saveUserData called with:');
    print('  - Token: ${token.substring(0, 10)}...');
    print('  - User ID: $userId');
    print('  - Name: $name');
    print('  - Email: $email');
    print('  - Phone: $phone');

    await saveToken(token);
    await saveUserId(userId);
    if (name != null && name.isNotEmpty) {
      await saveUserName(name);
    } else {
      print('⚠️ Name is null or empty, not saving');
    }
    if (email != null && email.isNotEmpty) {
      await saveUserEmail(email);
    } else {
      print('⚠️ Email is null or empty, not saving');
    }
    if (phone != null && phone.isNotEmpty) {
      await saveUserPhone(phone);
    } else {
      print('⚠️ Phone is null or empty, not saving');
    }
    await saveLoginStatus(true);
    await _createSession();
    print('✅ All user data saved successfully');
  }

  // Session Management Methods

  // Create a new session
  static Future<void> _createSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentTime = DateTime.now().toIso8601String();

    await prefs.setString(_keySessionId, sessionId);
    await prefs.setString(_keyLastLoginTime, currentTime);
    await prefs.setString(_keySessionStartTime, currentTime);

    print('🔐 New session created: $sessionId at $currentTime');
  }

  // Get session ID
  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionId);
  }

  // Get last login time
  static Future<String?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastLoginTime);
  }

  // Get session start time
  static Future<String?> getSessionStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySessionStartTime);
  }

  // Update last login time
  static Future<void> updateLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().toIso8601String();
    await prefs.setString(_keyLastLoginTime, currentTime);
    print('🕐 Last login time updated: $currentTime');
  }

  // Check if session is valid (within 30 days)
  static Future<bool> isSessionValid() async {
    final lastLoginTime = await getLastLoginTime();
    if (lastLoginTime == null) return false;

    try {
      final lastLogin = DateTime.parse(lastLoginTime);
      final now = DateTime.now();
      final difference = now.difference(lastLogin).inDays;

      final isValid = difference <= 30;
      print(
        '🔍 Session validation: ${isValid ? "Valid" : "Expired"} (${difference} days old)',
      );
      return isValid;
    } catch (e) {
      print('❌ Error parsing session time: $e');
      return false;
    }
  }

  // Get session duration in minutes
  static Future<int> getSessionDuration() async {
    final sessionStartTime = await getSessionStartTime();
    if (sessionStartTime == null) return 0;

    try {
      final startTime = DateTime.parse(sessionStartTime);
      final now = DateTime.now();
      final duration = now.difference(startTime).inMinutes;
      return duration;
    } catch (e) {
      print('❌ Error calculating session duration: $e');
      return 0;
    }
  }

  // Clear session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionId);
    await prefs.remove(_keyLastLoginTime);
    await prefs.remove(_keySessionStartTime);
    print('🗑️ Session data cleared');
  }
}

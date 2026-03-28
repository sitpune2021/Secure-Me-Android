import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorHelper {
  /// Maps a network response or status code to a user-friendly message.
  /// Hides technical system error codes from the end user.
  static String getFriendlyMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      
      // If the API provided a clear message, use it
      if (data != null && data['message'] != null) {
        return data['message'].toString();
      }
      
      // Handle Laravel-style validation errors
      if (data != null && data['errors'] != null) {
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            // Just return the first error message for simplicity and cleanliness
            final firstKey = errors.keys.first;
            final firstErrorList = errors[firstKey];
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              return firstErrorList[0].toString();
            }
            return errors.values.first.toString();
          }
        }
        return "Validation failed. Please check your inputs.";
      }
    } catch (_) {
      // If parsing fails, fall back to status code mapping
    }

    // Status code fallback mapping
    switch (response.statusCode) {
      case 400:
        return "The request was invalid. Please check your information.";
      case 401:
        return "Your session has expired or the credentials are incorrect.";
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return "The requested service was not found. Please try again later.";
      case 405:
        return "This action is not allowed at the moment.";
      case 422:
        return "The provided information is invalid or already exists.";
      case 429:
        return "Too many attempts. Please wait a moment and try again.";
      case 500:
        return "Our servers are experiencing issues. We're working on it!";
      case 503:
        return "System maintenance in progress. Please check back later.";
      default:
        // Generic but safe message
        return "Something went wrong. Please try again.";
    }
  }

  /// Returns a friendly title based on the status code category
  static String getErrorTitle(int statusCode) {
    if (statusCode >= 500) return "Server Busy";
    if (statusCode == 401) return "Authentication Issue";
    if (statusCode == 403) return "Access Denied";
    if (statusCode == 422) return "Submission Error";
    if (statusCode == 429) return "Too Busy";
    return "Error Occurred";
  }
}

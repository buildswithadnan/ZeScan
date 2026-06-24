import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

/// Utility class for handling API errors and converting them to user-friendly messages
class ApiErrorHandler {
  /// Parse HTTP response and exception to return user-friendly error message
  static String getUserFriendlyMessage(dynamic error, {http.Response? response}) {
    // Handle HTTP response status codes
    if (response != null) {
      switch (response.statusCode) {
        case 400:
          return 'Invalid request. Please check your input and try again.';
        case 401:
          return 'Authentication failed. Please log in again.';
        case 403:
          return 'Access denied. You don\'t have permission to perform this action.';
        case 404:
          return 'The requested resource was not found.';
        case 408:
          return 'Request timed out. Please try again.';
        case 413:
          return 'Your request is too large. Please reduce the size and try again.';
        case 429:
          return 'Too many requests. Please wait a moment and try again.';
        case 500:
          return 'Server error. Please try again later.';
        case 502:
          return 'Bad gateway. Our server is temporarily unavailable.';
        case 503:
          return 'Service unavailable. Please try again later.';
        case 504:
          return 'Gateway timeout. Please try again.';
        default:
          if (response.statusCode >= 500) {
            return 'Server error. Please try again later.';
          } else if (response.statusCode >= 400) {
            return 'Request failed. Please try again.';
          }
      }
    }

    // Handle specific exception types
    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error is FormatException) {
      return 'Invalid response from server. Please try again later.';
    } else if (error is http.ClientException) {
      return 'Network error. Please check your connection and try again.';
    } else if (error is HandshakeException) {
      return 'Security error. Please check your device date/time settings.';
    } else if (error is CertificateException) {
      return 'Security certificate error. Please check your device date/time settings.';
    }

    // Check error message for specific patterns
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorStr.contains('permission')) {
      return 'Permission denied. Please check your app permissions.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('certificate') || errorStr.contains('ssl') || errorStr.contains('handshake')) {
      return 'Security error. Please check your device date/time settings.';
    } else if (errorStr.contains('host') || errorStr.contains('dns')) {
      return 'Cannot reach server. Please check your internet connection.';
    } else if (errorStr.contains('cancelled') || errorStr.contains('canceled')) {
      return 'Request was cancelled.';
    }

    // Default generic message
    return 'Something went wrong. Please try again.';
  }

  /// Check if error is a network connectivity issue
  static bool isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is http.ClientException) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('network') || 
           errorStr.contains('connection') ||
           errorStr.contains('host') ||
           errorStr.contains('dns');
  }

  /// Check if error is a timeout issue
  static bool isTimeoutError(dynamic error) {
    if (error is TimeoutException) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('timeout');
  }

  /// Check if error is a permission issue
  static bool isPermissionError(dynamic error, {http.Response? response}) {
    if (response != null && (response.statusCode == 401 || response.statusCode == 403)) {
      return true;
    }
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('permission') || 
           errorStr.contains('unauthorized') ||
           errorStr.contains('forbidden');
  }

  /// Check if error is a server error (5xx)
  static bool isServerError(http.Response? response) {
    return response != null && response.statusCode >= 500 && response.statusCode < 600;
  }

  /// Check if error is a client error (4xx)
  static bool isClientError(http.Response? response) {
    return response != null && response.statusCode >= 400 && response.statusCode < 500;
  }

  /// Log error for debugging (only in debug mode)
  static void logError(String context, dynamic error, {http.Response? response, StackTrace? stackTrace}) {
    assert(() {
      print('=== API Error in $context ===');
      print('Error: $error');
      if (response != null) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      if (stackTrace != null) {
        print('Stack Trace: $stackTrace');
      }
      print('===========================');
      return true;
    }());
  }
}

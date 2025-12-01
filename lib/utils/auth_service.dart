import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://cop4331-group2.me/api';

  // Store user data
  static String? _userId;
  static String? _firstName;
  static String? _lastName;
  static String? _email;
  static String? _login;
  static bool _emailVerified = false;

  // Getters
  static bool get isLoggedIn => _userId != null;
  static String? get firstName => _firstName;
  static String? get lastName => _lastName;
  static String? get userId => _userId;
  static String? get email => _email;
  static String? get login => _login;
  static bool get emailVerified => _emailVerified;

  /// Check login status
  static Future<bool> checkLoginStatus() async {
    return _userId != null && _emailVerified;
  }

  /// Signup - creates new user account
  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String login,
    required String password,
  }) async {
    print('🔵 AUTH: Starting signup...');
    print('🔵 URL: $baseUrl/signup');
    print('🔵 Data: firstName=$firstName, lastName=$lastName, email=$email, login=$login');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'login': login,
          'password': password,
        }),
      );

      print('🔵 Response Status: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['id'] != '-1') {
        print('✅ Signup successful!');
        return {
          'success': true,
          'id': data['id'],
          'message': 'Account created! Please check your email to verify.',
        };
      } else {
        print('❌ Signup failed: ${data['error']}');
        throw Exception(data['error'] ?? 'Signup failed');
      }
    } catch (e) {
      print('❌ Signup error: $e');
      throw Exception('Signup error: $e');
    }
  }

  /// Verify email with token
  static Future<bool> verifyEmail(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data['alreadyVerified'] == true || data['error'].isEmpty;
      }
      return false;
    } catch (e) {
      throw Exception('Verification error: $e');
    }
  }

  /// Login with username/email and password
  static Future<Map<String, dynamic>> userLogin(String loginOrEmail, String password) async {
    print('🔵 AUTH: Starting login...');
    print('🔵 URL: $baseUrl/login');
    print('🔵 Login/Email: $loginOrEmail');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': loginOrEmail,
          'password': password,
        }),
      );

      print('🔵 Response Status: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['id'] != '-1') {
        print('✅ Login successful!');
        _userId = data['id'];
        _firstName = data['firstName'];
        _lastName = data['lastName'];
        _emailVerified = data['emailVerified'] ?? false;
        _login = loginOrEmail;

        return {
          'success': true,
          'id': data['id'],
          'firstName': data['firstName'],
          'lastName': data['lastName'],
          'emailVerified': data['emailVerified'],
        };
      } else if (response.statusCode == 403) {
        print('❌ Email not verified');
        throw Exception('Please verify your email before logging in');
      } else {
        print('❌ Login failed: ${data['error']}');
        throw Exception(data['error'] ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Login error: $e');
    }
  }

  /// Request password reset
  static Future<void> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password-request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['error'] ?? 'Password reset request failed');
      }
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }

  /// Reset password with token
  static Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['error'] ?? 'Password reset failed');
      }
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }

  /// Resend verification email
  static Future<void> resendVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['error'] ?? 'Resend verification failed');
      }
    } catch (e) {
      throw Exception('Resend verification error: $e');
    }
  }

  /// Logout
  static Future<void> logout() async {
    _userId = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _login = null;
    _emailVerified = false;
  }
}
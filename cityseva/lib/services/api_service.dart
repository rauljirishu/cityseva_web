import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Configuration - change this to your backend URL
  static const String _baseUrl = 'http://localhost:3000/api';
  static const Duration _timeout = Duration(seconds: 15);

  // ─── User Endpoints ────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> getUser(String email) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users/$email'),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {};
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createOrUpdateUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userData),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  // ─── Complaint Endpoints ──────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getAllComplaints() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/complaints')).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map && decoded.containsKey('data')) {
          return List<Map<String, dynamic>>.from(decoded['data']);
        }
        return [];
      }
      throw Exception('Failed to fetch complaints: ${response.statusCode}');
    } catch (e) {
      print('Error fetching complaints: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getComplaintsByUserId(
      String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/complaints/user/$userId'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map && decoded.containsKey('data')) {
          return List<Map<String, dynamic>>.from(decoded['data']);
        }
        return [];
      }
      throw Exception('Failed to fetch complaints: ${response.statusCode}');
    } catch (e) {
      print('Error fetching user complaints: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createComplaint(
      Map<String, dynamic> complaintData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/complaints'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(complaintData),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create complaint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating complaint: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateComplaint(
      String complaintId, Map<String, dynamic> updates) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/complaints/$complaintId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(updates),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update complaint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating complaint: $e');
      rethrow;
    }
  }

  // ─── Feedback Endpoints ───────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getAllFeedbacks() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/feedbacks')).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map && decoded.containsKey('data')) {
          return List<Map<String, dynamic>>.from(decoded['data']);
        }
        return [];
      }
      throw Exception('Failed to fetch feedbacks: ${response.statusCode}');
    } catch (e) {
      print('Error fetching feedbacks: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createFeedback(
      Map<String, dynamic> feedbackData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/feedbacks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(feedbackData),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create feedback: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating feedback: $e');
      rethrow;
    }
  }

  // ─── Health Check ────────────────────────────────────────────────────────

  static Future<bool> healthCheck() async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl.replaceAll('/api', ''))).timeout(
                const Duration(seconds: 5),
              );
      return response.statusCode == 200;
    } catch (e) {
      print('Backend health check failed: $e');
      return false;
    }
  }
}

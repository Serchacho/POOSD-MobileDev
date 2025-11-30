import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ListService {
  static const String baseUrl = 'http://10.0.2.2:5001/api';

  /// Get authorization headers
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-User-Id': AuthService.userId ?? '',
    };
  }

  /// Get all lists for current user
  static Future<List<Map<String, dynamic>>> getLists() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lists'),
        headers: _getHeaders(),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final lists = data['data'] as List;
        return lists.map((list) => list as Map<String, dynamic>).toList();
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch lists');
      }
    } catch (e) {
      throw Exception('Get lists error: $e');
    }
  }

  /// Create new shopping list
  static Future<Map<String, dynamic>> createList({
    required String name,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lists/create'),
        headers: _getHeaders(),
        body: json.encode({
          'name': name,
          'description': description,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to create list');
      }
    } catch (e) {
      throw Exception('Create list error: $e');
    }
  }

  /// Join list by code
  static Future<Map<String, dynamic>> joinList(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lists/join'),
        headers: _getHeaders(),
        body: json.encode({'code': code}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to join list');
      }
    } catch (e) {
      throw Exception('Join list error: $e');
    }
  }

  /// Get list details and items
  static Future<Map<String, dynamic>> getListDetails(String listId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lists/$listId'),
        headers: _getHeaders(),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch list details');
      }
    } catch (e) {
      throw Exception('Get list details error: $e');
    }
  }

  /// Update list name/description
  static Future<Map<String, dynamic>> updateList({
    required String listId,
    String? name,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;

      final response = await http.put(
        Uri.parse('$baseUrl/lists/$listId'),
        headers: _getHeaders(),
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to update list');
      }
    } catch (e) {
      throw Exception('Update list error: $e');
    }
  }

  /// Delete list (creator only)
  static Future<void> deleteList(String listId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/lists/$listId'),
        headers: _getHeaders(),
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['error'] ?? 'Failed to delete list');
      }
    } catch (e) {
      throw Exception('Delete list error: $e');
    }
  }

  /// Leave list
  static Future<void> leaveList(String listId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lists/$listId/leave'),
        headers: _getHeaders(),
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['error'] ?? 'Failed to leave list');
      }
    } catch (e) {
      throw Exception('Leave list error: $e');
    }
  }

  /// Add item to list
  static Future<Map<String, dynamic>> addItem({
    required String listId,
    required String name,
    int quantity = 1,
    double? weight,
    String? weightUnit,
  }) async {
    try {
      final body = {
        'name': name,
        'quantity': quantity,
      };
      if (weight != null) body['weight'] = weight;
      if (weightUnit != null) body['weightUnit'] = weightUnit;

      final response = await http.post(
        Uri.parse('$baseUrl/lists/$listId/items'),
        headers: _getHeaders(),
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to add item');
      }
    } catch (e) {
      throw Exception('Add item error: $e');
    }
  }

  /// Update item
  static Future<Map<String, dynamic>> updateItem({
    required String listId,
    required String itemId,
    String? name,
    int? quantity,
    bool? purchased,
    double? weight,
    String? weightUnit,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (quantity != null) body['quantity'] = quantity;
      if (purchased != null) body['purchased'] = purchased;
      if (weight != null) body['weight'] = weight;
      if (weightUnit != null) body['weightUnit'] = weightUnit;

      final response = await http.put(
        Uri.parse('$baseUrl/lists/$listId/items/$itemId'),
        headers: _getHeaders(),
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to update item');
      }
    } catch (e) {
      throw Exception('Update item error: $e');
    }
  }

  /// Delete item
  static Future<void> deleteItem({
    required String listId,
    required String itemId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/lists/$listId/items/$itemId'),
        headers: _getHeaders(),
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['error'] ?? 'Failed to delete item');
      }
    } catch (e) {
      throw Exception('Delete item error: $e');
    }
  }

  /// Get app stats (public endpoint)
  static Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch stats');
      }
    } catch (e) {
      throw Exception('Get stats error: $e');
    }
  }
}
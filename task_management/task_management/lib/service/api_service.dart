import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8080/api';
  String? token; // to store JWT token after login

  // Constructor to initialize the token from shared preferences (if available)
  ApiService() {
    _loadToken();
  }

  // Load token from shared preferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  // Save token to shared preferences
  Future<void> _saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    token = newToken;
  }

  // Method to get headers (including token if logged in)
  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };

    // If the token is available, add it to the headers
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Method for user registration
  Future<void> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      );

      if (response.statusCode == 201) {
        // Registration successful
        return;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (error) {
      // Handle error (network issue, server error, etc.)
      throw Exception('Registration failed. Please check your network connection or try again later.');
    }
  }

  // Method for user login, stores the JWT token for future requests
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String newToken = data['token'];
      await _saveToken(newToken); // Save token
      return data; // Return the data to be processed in the AuthProvider
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Method to create a task
  Future<Task> createTask(Map<String, dynamic> taskData) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: headers,
      body: jsonEncode(taskData),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  // Method to update a task
  Future<Task> updateTask(int taskId, Map<String, dynamic> taskData) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: headers,
      body: jsonEncode(taskData),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  // Method to delete a task
  Future<void> deleteTask(int taskId) async {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }

  // Method to get all users
  Future<List<User>> getUsers() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  // Method to get all tasks
  Future<List<Task>> getTasks() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.body}');
    }
  }
}

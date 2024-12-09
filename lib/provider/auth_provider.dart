import 'package:flutter/material.dart';

import '../service/api_service.dart';


class AuthProvider with ChangeNotifier {
  // Authentication state
  bool _isAuthenticated = false;
  String _userToken = '';
  String _errorMessage = ''; // To store error messages

  // Getter for authentication status
  bool get isAuthenticated => _isAuthenticated;

  // Getter for the user token (if applicable)
  String get userToken => _userToken;

  // Getter for error message
  String get errorMessage => _errorMessage;

  // Method to handle login
  Future<void> login(String username, String password) async {
    try {
      // API call for login using ApiService
      final response = await ApiService().login(username, password);

      // Checking if the response contains a valid token
      if (response.containsKey('token')) {
        _userToken = response['token']; // Assuming the token is returned in the response
        _isAuthenticated = true;
        _errorMessage = '';
      } else {
        _errorMessage = 'Token not found in response data.';
      }
    } catch (error) {
      // Catch and set any unexpected errors
      _errorMessage = 'An error occurred during login: ${error.toString()}';
    }
    notifyListeners();
  }

  // Method to handle logout
  Future<void> logout() async {
    // Simulating an API call for logout (you can implement a real API call if needed)
    await Future.delayed(const Duration(seconds: 2));

    _isAuthenticated = false;
    _userToken = '';
    notifyListeners(); // Notify listeners of changes
  }

  // Method to handle registration
  Future<void> register(String username, String password, String confirmPassword) async {
    // Validate user input
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'All fields are required.';
      notifyListeners();
      return;
    }
    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match.';
      notifyListeners();
      return;
    }

    try {
      // Call the API service to register the user
      await ApiService().register(username, password);
      _errorMessage = ''; // Reset error message on successful registration
    } catch (error) {
      // Catch and set any unexpected errors
      _errorMessage = 'An error occurred during registration: ${error.toString()}';
    }
    notifyListeners();
  }

  // Method to check if user is logged in
  bool checkAuthStatus() {
    return _isAuthenticated;
  }
}

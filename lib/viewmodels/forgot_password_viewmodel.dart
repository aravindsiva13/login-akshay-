import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> sendResetLink(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if email exists in the system
      final emailExists = await _checkEmailExists(email);
      
      if (!emailExists) {
        _errorMessage = 'No account found with this email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simulate sending reset link (replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, you would make an API call here to send the reset email
      // For demo purposes, we'll just simulate success
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      // Get all users and check if email exists
      final users = await _authService.getAllUsers();
      return users.any((user) => user['email'] == email);
    } catch (e) {
      return false;
    }
  }
}
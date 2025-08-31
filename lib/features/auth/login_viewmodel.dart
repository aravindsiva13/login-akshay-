import 'package:flutter/foundation.dart';
import 'auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;

  Future<bool> login(String emailOrPhone, String password) async {
    isLoading = true;
    notifyListeners();

    final success = await _repository.login(emailOrPhone, password);

    isLoading = false;
    notifyListeners();

    return success;
  }
}

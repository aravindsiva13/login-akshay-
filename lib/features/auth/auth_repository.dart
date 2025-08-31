class AuthRepository {

  Future<bool> login(String emailOrPhone, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API call
    if ((emailOrPhone == "test@test.com" || emailOrPhone == "1234567890") &&
        password == "password") {
      return true;
    }
    return false;
  }
}

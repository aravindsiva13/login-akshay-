import '../models/user_model.dart';
import '../models/login_request_model.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    await StorageService.initialize();
  }

  Future<UserModel> login(LoginRequestModel request) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = await StorageService.getUser(request.email, request.password);
    
    if (user == null) {
      throw Exception('Invalid credentials');
    }
    
    _currentUser = user;
    return _currentUser!;
  }

  Future<UserModel> register(String email, String name, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    await StorageService.saveUser(email, name, password);

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );

    return _currentUser!;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await StorageService.getAllUsers();
  }

  Future<void> clearAllUsers() async {
    await StorageService.clearAllUsers();
    _currentUser = null;
  }
}
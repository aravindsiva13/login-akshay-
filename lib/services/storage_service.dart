// import 'dart:convert';
// import 'package:authdemo/models/user_model.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;


// // Conditional imports
// import 'dart:html' as html show window;
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class StorageService {
//   static const String _key = 'users_database';
//   static Database? _db;

//   static Future<void> initialize() async {
//     if (!kIsWeb) {
//       _db = await openDatabase(
//         join(await getDatabasesPath(), 'users.db'),
//         onCreate: (db, version) => db.execute(
//           'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, '
//           'email TEXT UNIQUE NOT NULL, name TEXT, password TEXT NOT NULL)',
//         ),
//         version: 1,
//       );
//     }
//   }

//   static Future<void> saveUser(String email, String name, String password) async {
//     if (kIsWeb) {
//       final storage = html.window.localStorage;
//       final users = jsonDecode(storage[_key] ?? '[]') as List;
      
//       if (users.any((u) => u['email'] == email)) {
//         throw Exception('Email already exists');
//       }
      
//       users.add({'id': DateTime.now().millisecondsSinceEpoch, 'email': email, 'name': name, 'password': password});
//       storage[_key] = jsonEncode(users);
//     } else {
//       try {
//         await _db!.insert('users', {'email': email, 'name': name, 'password': password});
//       } catch (e) {
//         throw Exception(e.toString().contains('UNIQUE') ? 'Email already exists' : 'Failed to create user');
//       }
//     }
//   }

//   static Future<UserModel?> getUser(String email, String password) async {
//     if (kIsWeb) {
//       final users = jsonDecode(html.window.localStorage[_key] ?? '[]') as List;
//       final user = users.firstWhere((u) => u['email'] == email && u['password'] == password, orElse: () => null);
//       return user != null ? UserModel(id: user['id'].toString(), email: user['email'], name: user['name']) : null;
//     } else {
//       final result = await _db!.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password], limit: 1);
//       return result.isNotEmpty ? UserModel(id: result.first['id'].toString(), email: result.first['email'] as String, name: result.first['name'] as String?) : null;
//     }
//   }

//   static Future<bool> emailExists(String email) async {
//     if (kIsWeb) {
//       final users = jsonDecode(html.window.localStorage[_key] ?? '[]') as List;
//       return users.any((u) => u['email'] == email);
//     } else {
//       final result = await _db!.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
//       return result.isNotEmpty;
//     }
//   }

//   static Future<List<Map<String, dynamic>>> getAllUsers() async {
//     if (kIsWeb) {
//       return (jsonDecode(html.window.localStorage[_key] ?? '[]') as List).cast<Map<String, dynamic>>();
//     } else {
//       return await _db!.query('users');
//     }
//   }

//   static Future<void> clearAllUsers() async {
//     if (kIsWeb) {
//       html.window.localStorage.remove(_key);
//     } else {
//       await _db!.delete('users');
//     }
//   }
// }


//2


import 'dart:convert';
import 'package:authdemo/models/user_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports
import 'dart:html' as html show window;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageService {
  static const String _key = 'users_database';
  static Database? _db;

  static Future<void> initialize() async {
    if (!kIsWeb) {
      await _initializeDatabase();
    }
  }

  static Future<void> _initializeDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'email TEXT UNIQUE NOT NULL, name TEXT, password TEXT NOT NULL)',
      ),
      version: 1,
    );
  }

  static Future<void> saveUser(String email, String name, String password) async {
    if (kIsWeb) {
      await _saveUserWeb(email, name, password);
    } else {
      await _saveUserMobile(email, name, password);
    }
  }

  static Future<void> _saveUserWeb(String email, String name, String password) async {
    final storage = html.window.localStorage;
    final users = jsonDecode(storage[_key] ?? '[]') as List;
    
    if (users.any((u) => u['email'] == email)) {
      throw Exception('Email already exists');
    }
    
    users.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'email': email,
      'name': name,
      'password': password
    });
    
    storage[_key] = jsonEncode(users);
  }

  static Future<void> _saveUserMobile(String email, String name, String password) async {
    try {
      await _db!.insert('users', {
        'email': email,
        'name': name,
        'password': password
      });
    } catch (e) {
      throw Exception(e.toString().contains('UNIQUE') ? 'Email already exists' : 'Failed to create user');
    }
  }

  static Future<UserModel?> getUser(String email, String password) async {
    if (kIsWeb) {
      return _getUserWeb(email, password);
    } else {
      return _getUserMobile(email, password);
    }
  }

  static Future<UserModel?> _getUserWeb(String email, String password) async {
    final users = jsonDecode(html.window.localStorage[_key] ?? '[]') as List;
    final user = users.cast<Map<String, dynamic>>().firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    
    if (user.isEmpty) return null;
    
    return UserModel(
      id: user['id'].toString(),
      email: user['email'],
      name: user['name'],
    );
  }

  static Future<UserModel?> _getUserMobile(String email, String password) async {
    final result = await _db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    
    if (result.isEmpty) return null;
    
    final user = result.first;
    return UserModel(
      id: user['id'].toString(),
      email: user['email'] as String,
      name: user['name'] as String?,
    );
  }

  static Future<bool> emailExists(String email) async {
    if (kIsWeb) {
      final users = jsonDecode(html.window.localStorage[_key] ?? '[]') as List;
      return users.any((u) => u['email'] == email);
    } else {
      final result = await _db!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      return result.isNotEmpty;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (kIsWeb) {
      return (jsonDecode(html.window.localStorage[_key] ?? '[]') as List)
          .cast<Map<String, dynamic>>();
    } else {
      return await _db!.query('users');
    }
  }

  static Future<void> clearAllUsers() async {
    if (kIsWeb) {
      html.window.localStorage.remove(_key);
    } else {
      await _db!.delete('users');
    }
  }
}
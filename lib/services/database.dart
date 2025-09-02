import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'database.g.dart';

// Define the users table
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get password => text()();
}

// Database class
@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(String email, String name, String password) async {
    return await into(users).insert(
      UsersCompanion(
        email: Value(email),
        name: Value(name),
        password: Value(password),
      ),
    );
  }

  Future<User?> getUser(String email, String password) async {
    return await (select(users)
          ..where((user) => user.email.equals(email) & user.password.equals(password)))
        .getSingleOrNull();
  }

  Future<bool> emailExists(String email) async {
    final user = await (select(users)..where((user) => user.email.equals(email))).getSingleOrNull();
    return user != null;
  }

  Future<List<User>> getAllUsers() async {
    return await select(users).get();
  }

  Future<void> clearAllUsers() async {
    await delete(users).go();
  }
}

// Simple web-only connection (no FFI errors)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return WebDatabase('users_db');
  });
}
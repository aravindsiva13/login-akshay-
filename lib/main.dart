// import 'package:flutter/material.dart';
// import 'views/pages/login_page.dart';
// import 'services/database_helper.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   try {
//     await DatabaseHelper.database;
//     print('SQLite Database initialized successfully');
//   } catch (e) {
//     print('Error initializing database: $e');
//   }
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: 'Inter', 
//       ),
//       home: const LoginPage(),
//     );
//   }
// }



//2


import 'package:flutter/material.dart';
import 'views/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', 
      ),
      home: const LoginPage(),
    );
  }
}
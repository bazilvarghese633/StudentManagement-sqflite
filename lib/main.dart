import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_try3/screens/addStudent.dart';
import 'package:student_try3/screens/studentlist.dart';
import 'functions/functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Status bar color
    statusBarIconBrightness:
        Brightness.dark, // Icon brightness (dark icons for white background)
    statusBarBrightness: Brightness
        .light, // For iOS: status bar content brightness (light background)
  ));
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "STUDENT DATABASE",
      theme: ThemeData(
        primaryColor: Colors.white, // Set primary color to white
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar background color to white
          iconTheme:
              IconThemeData(color: Colors.black), // Ensure icons are visible
          titleTextStyle:
              TextStyle(color: Colors.black), // Ensure title is visible
        ),
        scaffoldBackgroundColor:
            Colors.white, // Set the scaffold background color to white
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.black), // Set default text color to black
        ),
      ),
      home: StudentInfo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

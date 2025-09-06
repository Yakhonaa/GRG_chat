import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/registration_page.dart';

void main() {
  runApp(
    const MainApp(), // MyApp contains your MessageScreen
  );
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark)
              ),
      home: RegistrationPage(),
      );
  }
}

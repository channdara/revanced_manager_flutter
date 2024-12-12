import 'package:flutter/material.dart';

import 'src/presentation/screen/splash_screen.dart';

void main() {
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}

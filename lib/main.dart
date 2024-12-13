import 'package:flutter/material.dart';

import 'src/manager/callback_manager.dart';
import 'src/manager/preferences_manager.dart';
import 'src/presentation/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await PreferencesManager().themeMode();
  runApp(Application(themeMode: themeMode));
}

class Application extends StatefulWidget {
  const Application({super.key, required this.themeMode});

  final ThemeMode themeMode;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    CallbackManager().enableDarkModeCallback = (brightness) {
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'ProductSans',
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        cardTheme: const CardTheme(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'ProductSans',
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        cardTheme: const CardTheme(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
      ),
    );
  }
}

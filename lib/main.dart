import 'package:flutter/material.dart';

import 'src/base/base_stateful.dart';
import 'src/common/app_theme.dart';
import 'src/manager/callback_manager.dart';
import 'src/manager/download_manager.dart';
import 'src/manager/preferences_manager.dart';
import 'src/presentation/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await PreferencesManager().themeMode();
  final accentColor = await PreferencesManager().accentColor();
  runApp(Application(themeMode: themeMode, accentColor: accentColor));
}

class Application extends StatefulWidget {
  const Application({
    super.key,
    required this.themeMode,
    required this.accentColor,
  });

  final ThemeMode themeMode;
  final Color accentColor;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends BaseStateful<Application> {
  ThemeMode? _themeMode;
  Color? _accentColor;

  @override
  void initState() {
    super.initState();
    CallbackManager().enableDarkModeCallback = (brightness) {
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      setState(() {});
    };
    CallbackManager().updateAccentColorCallback = (color) {
      _accentColor = color;
      setState(() {});
    };
  }

  @override
  void dispose() {
    DownloadManager().cancelAllDownloading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      themeMode: _themeMode ?? widget.themeMode,
      theme: AppTheme.lightTheme(_accentColor ?? widget.accentColor),
      darkTheme: AppTheme.darkTheme(_accentColor ?? widget.accentColor),
    );
  }
}

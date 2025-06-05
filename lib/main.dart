import 'package:flutter/material.dart';

import 'src/base/base_stateful.dart';
import 'src/common/app_text_style.dart';
import 'src/common/common.dart';
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
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: AppCommon.fontFamily,
        colorSchemeSeed: _accentColor ?? widget.accentColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: AppTextStyle.appBarTitleTextStyle,
          actionsPadding: EdgeInsets.only(right: 8.0),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          year2023: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppTextStyle.s12Bold
                : AppTextStyle.s12;
          }),
        ),
        tabBarTheme: TabBarThemeData(
          labelStyle:
              AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
          unselectedLabelStyle:
              AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppCommon.fontFamily,
        colorSchemeSeed: _accentColor ?? widget.accentColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: AppTextStyle.appBarDarkTitleTextStyle,
          actionsPadding: EdgeInsets.only(right: 8.0),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          year2023: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppTextStyle.s12Bold
                : AppTextStyle.s12;
          }),
        ),
        tabBarTheme: TabBarThemeData(
          labelStyle:
              AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
          unselectedLabelStyle:
              AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
        ),
      ),
    );
  }
}

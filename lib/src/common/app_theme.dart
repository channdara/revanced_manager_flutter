import 'package:flutter/material.dart';

import 'app_text_style.dart';
import 'common.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(Color colorSchemeSeed) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppCommon.fontFamily,
      colorSchemeSeed: colorSchemeSeed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      elevatedButtonTheme: _elevatedButtonTheme,
      iconTheme: const IconThemeData(color: Colors.black),
      cardTheme: _cardTheme,
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFF8F9FF),
        titleTextStyle: AppTextStyle.appBarTitleTextStyle,
        actionsPadding: EdgeInsets.only(right: 8.0),
      ),
      progressIndicatorTheme: _progressIndicatorTheme,
      navigationBarTheme: _navigationBarTheme,
      tabBarTheme: _tabBarTheme,
    );
  }

  static ThemeData darkTheme(Color colorSchemeSeed) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppCommon.fontFamily,
      colorSchemeSeed: colorSchemeSeed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      scaffoldBackgroundColor: const Color(0xFF111418),
      elevatedButtonTheme: _elevatedButtonTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      cardTheme: _cardTheme,
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFF111418),
        titleTextStyle: AppTextStyle.appBarDarkTitleTextStyle,
        actionsPadding: EdgeInsets.only(right: 8.0),
      ),
      progressIndicatorTheme: _progressIndicatorTheme,
      navigationBarTheme: _navigationBarTheme,
      tabBarTheme: _tabBarTheme,
    );
  }

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0.0,
      shadowColor: Colors.transparent,
    ),
  );

  static const CardThemeData _cardTheme = CardThemeData(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAliasWithSaveLayer,
  );

  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(year2023: false);

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? AppTextStyle.s12Bold
          : AppTextStyle.s12;
    }),
  );

  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelStyle: AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
    unselectedLabelStyle:
        AppTextStyle.s14.copyWith(fontFamily: AppCommon.fontFamily),
  );
}

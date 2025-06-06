import 'package:flutter/material.dart';

import 'common.dart';

class AppTextStyle {
  AppTextStyle._();

  /// FontVariation section
  static const List<FontVariation> _normal = [FontVariation.weight(400.0)];
  static const List<FontVariation> _bold = [FontVariation.weight(700.0)];

  /// Font Size: 10
  static const TextStyle s10 =
      TextStyle(fontSize: 10.0, fontVariations: _normal);

  /// Font Size: 12
  static const TextStyle s12 =
      TextStyle(fontSize: 12.0, fontVariations: _normal);
  static const TextStyle s12Bold =
      TextStyle(fontSize: 12.0, fontVariations: _bold);
  static const TextStyle s12BoldGreen =
      TextStyle(fontSize: 12.0, fontVariations: _bold, color: Colors.green);
  static const TextStyle s12Grey = TextStyle(
    fontSize: 12.0,
    fontVariations: _normal,
    color: Colors.grey,
  );
  static const TextStyle s12Green = TextStyle(
    fontSize: 12.0,
    fontVariations: _normal,
    color: Colors.green,
  );
  static const TextStyle s12Blue = TextStyle(
    fontSize: 12.0,
    fontVariations: _normal,
    color: Colors.blue,
  );

  /// Font Size: 14
  static const TextStyle s14 =
      TextStyle(fontSize: 14.0, fontVariations: _normal);
  static const TextStyle s14Bold =
      TextStyle(fontSize: 14.0, fontVariations: _bold);

  /// Font Size: 16
  static const TextStyle s16 =
      TextStyle(fontSize: 16.0, fontVariations: _normal);
  static const TextStyle s16Bold =
      TextStyle(fontSize: 16.0, fontVariations: _bold);

  /// Font Size: 18
  static const TextStyle s18 =
      TextStyle(fontSize: 18.0, fontVariations: _normal);
  static const TextStyle s18Bold =
      TextStyle(fontSize: 18.0, fontVariations: _bold);

  /// Font Size: 22
  static const TextStyle appBarTitleTextStyle = TextStyle(
    fontSize: 22.0,
    fontFamily: AppCommon.fontFamily,
    fontVariations: _normal,
    color: Colors.black,
  );
  static const TextStyle appBarDarkTitleTextStyle = TextStyle(
    fontSize: 22.0,
    fontFamily: AppCommon.fontFamily,
    fontVariations: _normal,
    color: Colors.white,
  );
  static const TextStyle s22 =
      TextStyle(fontSize: 22.0, fontVariations: _normal);
}

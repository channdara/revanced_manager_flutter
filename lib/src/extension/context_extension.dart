import 'package:flutter/material.dart';

double? _bottom;

extension ContextExtension on BuildContext {
  EdgeInsets defaultListPadding() {
    _bottom ??= MediaQuery.paddingOf(this).bottom;
    const padding = EdgeInsets.all(16.0);
    return padding.copyWith(bottom: padding.bottom + _bottom!);
  }
}

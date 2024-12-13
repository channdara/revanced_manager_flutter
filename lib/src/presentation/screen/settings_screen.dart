import 'package:flutter/material.dart';

import '../../base/base_stateful.dart';
import '../../manager/callback_manager.dart';
import '../../manager/preferences_manager.dart';
import '../dialog/preset_color_picker_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BaseStateful<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 32.0),
              title: Text(
                'App Theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              title: const Text('Enable Dark Mode'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  final brightness = value ? Brightness.dark : Brightness.light;
                  PreferencesManager().themeMode(brightness);
                  CallbackManager().enableDarkModeCallback?.call(brightness);
                },
              ),
            ),
            ListTile(
              title: const Text('Accent Color'),
              trailing: IconButton(
                onPressed: () {
                  showPresetColorPickerDialog(context).then((color) {
                    if (color == null) return;
                    PreferencesManager().accentColor(color);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      CallbackManager().updateAccentColorCallback?.call(color);
                    });
                  });
                },
                icon: Icon(
                  Icons.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

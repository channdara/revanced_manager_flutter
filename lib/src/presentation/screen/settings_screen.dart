import 'package:flutter/material.dart';

import '../../manager/callback_manager.dart';
import '../../manager/preferences_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                onPressed: () {},
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

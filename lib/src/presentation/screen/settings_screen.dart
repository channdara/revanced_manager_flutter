import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void _openLinkInExternalBrowser(String? uri) {
    if (uri == null || uri.isEmpty) return;
    launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
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
                    trailing: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          final brightness =
                              value ? Brightness.dark : Brightness.light;
                          PreferencesManager().themeMode(brightness);
                          CallbackManager()
                              .enableDarkModeCallback
                              ?.call(brightness);
                        },
                      ),
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
                            CallbackManager()
                                .updateAccentColorCallback
                                ?.call(color);
                          });
                        });
                      },
                      icon: Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Credit To The Owner',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _openLinkInExternalBrowser('https://ko-fi.com/rvmanager');
                    },
                    title: const Text('Support Original Project on Ko-fi'),
                    trailing: const Icon(Icons.coffee_rounded),
                  ),
                  ListTile(
                    onTap: () {
                      _openLinkInExternalBrowser(
                        'https://github.com/revancedapps/revancedmanager',
                      );
                    },
                    title: const Text('Original Project Source Code'),
                    trailing: const Icon(Icons.code_rounded),
                  ),
                  ListTile(
                    onTap: () {
                      _openLinkInExternalBrowser('https://revanced.net');
                    },
                    title: const Text('Original Project Website'),
                    trailing: const Icon(Icons.public_rounded),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'If You Like This Project',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _openLinkInExternalBrowser(
                        'https://www.buymeacoffee.com/eamchanndara',
                      );
                    },
                    title: const Text('Buy me a Coffee'),
                    trailing: const Icon(Icons.coffee_rounded),
                  ),
                  ListTile(
                    onTap: () {
                      _openLinkInExternalBrowser(
                        'https://github.com/channdara/revanced_manager_flutter',
                      );
                    },
                    title: const Text('This Project Source Code'),
                    trailing: const Icon(Icons.code_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

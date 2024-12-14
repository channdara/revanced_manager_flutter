import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../manager/callback_manager.dart';
import '../../../manager/preferences_manager.dart';
import '../../dialog/preset_color_picker_dialog.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_bloc_state.dart';
import 'widget/settings_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState
    extends BaseStatefulBloc<SettingsScreen, SettingsBloc> {
  @override
  SettingsBloc bloc = SettingsBloc();

  @override
  void initState() {
    super.initState();
    bloc.getCurrentAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsItemWidget(
              titleLabel: 'App Theme',
              children: [
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
            SettingsItemWidget(
              titleLabel: 'Credit To The Owner',
              children: [
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://ko-fi.com/rvmanager',
                    );
                  },
                  title: const Text('Support ReVanced on Ko-fi'),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/revancedapps/revancedmanager',
                    );
                  },
                  title: const Text('ReVanced Source Code'),
                  trailing: const Icon(Icons.code_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser('https://revanced.net');
                  },
                  title: const Text('ReVanced Website'),
                  trailing: const Icon(Icons.public_rounded),
                ),
              ],
            ),
            SettingsItemWidget(
              titleLabel: 'If You Like This Project',
              children: [
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://www.buymeacoffee.com/eamchanndara',
                    );
                  },
                  title: const Text('Buy me a Coffee'),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/channdara/revanced_manager_flutter',
                    );
                  },
                  title: const Text('This Project Source Code'),
                  trailing: const Icon(Icons.code_rounded),
                ),
              ],
            ),
            if (kDebugMode)
              SettingsItemWidget(
                titleLabel: 'Update Manager',
                trailingTitle: bloc.builder(
                  buildWhen: (p, c) => c is SettingsStateGotCurrentVersion,
                  builder: (context, state) {
                    return Text('v${bloc.currentVersion}');
                  },
                ),
                children: [
                  bloc.builder(
                    builder: (context, state) {
                      return ListTile(
                        title: const Text('Check for Updates'),
                        subtitle: state is AppBlocStateLoading ||
                                state is SettingsStateUpdateAvailable
                            ? LinearProgressIndicator(
                                value: bloc.progressing,
                                borderRadius: BorderRadius.circular(4.0),
                              )
                            : Text(
                                'Last Check: ${bloc.lastUpdateCheck}',
                                style: const TextStyle(fontSize: 12.0),
                              ),
                        trailing: IconButton(
                          onPressed: () {
                            bloc.checkForUpdate();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

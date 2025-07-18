import 'package:flutter/material.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../common/app_text_style.dart';
import '../../../extension/int_extension.dart';
import '../../../manager/callback_manager.dart';
import '../../../manager/preferences_manager.dart';
import '../../dialog/clear_cache_dialog.dart';
import '../../dialog/preset_color_picker_dialog.dart';
import '../changelog_screen/changelog_screen.dart';
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
    bloc.initialRequiredData();
    CallbackManager().reloadSettingScreenCallback = () {
      bloc.initialRequiredData();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsItemWidget(
              titleLabel: 'App Theme',
              children: [
                ListTile(
                  dense: true,
                  title: const Text(
                    'Enable Dark Mode',
                    style: AppTextStyle.s14,
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
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
                  dense: true,
                  title: const Text(
                    'Accent Color',
                    style: AppTextStyle.s14,
                  ),
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
              titleLabel: 'Storage Manager',
              children: [
                ListTile(
                  dense: true,
                  title: bloc.builder(
                    buildWhen: (p, c) => c is SettingsStateDirectoryCacheSize,
                    builder: (context, state) {
                      final size = bloc.totalCacheSize.toFileSize();
                      return Text(
                        'Clear Cache $size',
                        style: AppTextStyle.s14,
                      );
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showClearCacheDialog(context, () {
                        bloc.clearCache();
                      });
                    },
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ),
              ],
            ),
            SettingsItemWidget(
              titleLabel: 'Update Manager',
              trailingTitle: bloc.builder(
                buildWhen: (p, c) => c is SettingsStateGotCurrentVersion,
                builder: (context, state) {
                  return Text(
                    'v${bloc.currentVersion}',
                    style: AppTextStyle.s12Bold,
                  );
                },
              ),
              children: [
                bloc.builder(
                  builder: (context, state) {
                    final showLoadingProgress = state is AppBlocStateLoading ||
                        state is SettingsStateDownloadingUpdate;
                    return ListTile(
                      dense: true,
                      title: const Text(
                        'Check for Updates',
                        style: AppTextStyle.s14,
                      ),
                      subtitle: showLoadingProgress
                          ? LinearProgressIndicator(
                              value: bloc.progressing,
                              borderRadius: BorderRadius.circular(4.0),
                            )
                          : Text(
                              'Last check on ${bloc.lastUpdateCheck}',
                              style: AppTextStyle.s10,
                            ),
                      trailing: IconButton(
                        onPressed: bloc.isLoading || bloc.downloading
                            ? null
                            : bloc.checkForUpdate,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    );
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<dynamic>(
                        builder: (_) => const ChangelogScreen()));
                  },
                  dense: true,
                  title: const Text(
                    'Changelog',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

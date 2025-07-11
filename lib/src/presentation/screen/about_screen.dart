import 'package:flutter/material.dart';

import '../../base/base_stateful_bloc.dart';
import '../../common/app_text_style.dart';
import 'settings_screen/bloc/settings_bloc.dart';
import 'settings_screen/widget/settings_item_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends BaseStatefulBloc<AboutScreen, SettingsBloc> {
  @override
  SettingsBloc bloc = SettingsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsItemWidget(
              titleLabel: 'Credit to the original RV Manager',
              children: [
                const ListTile(
                  dense: true,
                  subtitle: Text(
                    "RV Manager, your go-to tool for managing RV apps and other modded APKs. RV Manager is inspired by the old popular app named Vanced Manager. We've taken the concept and enhanced it to provide you with a seamless experience in managing and updating your favorite apps.",
                    style: AppTextStyle.s12,
                  ),
                ),
                // ListTile(
                //   onTap: () {
                //     bloc.openLinkInExternalBrowser(
                //       'https://revanced.app/donate',
                //     );
                //   },
                //   dense: true,
                //   title: const Text(
                //     'Support RV Manager',
                //     style: AppTextStyle.s14,
                //   ),
                //   trailing: const Icon(Icons.coffee_rounded),
                // ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/vancedapps/rv-manager',
                    );
                  },
                  dense: true,
                  title: const Text(
                    'RV Manager GitHub',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.code_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser('https://vanced.to');
                  },
                  dense: true,
                  title: const Text(
                    'RV Website',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.public_rounded),
                ),
              ],
            ),
            SettingsItemWidget(
              titleLabel: 'Revanced Manager',
              children: [
                const ListTile(
                  dense: true,
                  subtitle: Text(
                    'A fun project, rebuilding the original RV Manager using Flutter framework with Material 3 design. Please refer to the original website or applications by the sources above. If you like this project, a cup of coffee would be appreciated.',
                    style: AppTextStyle.s12,
                  ),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://www.buymeacoffee.com/eamchanndara',
                    );
                  },
                  dense: true,
                  title: const Text(
                    'Buy me a Coffee',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://ko-fi.com/eamchanndara',
                    );
                  },
                  dense: true,
                  title: const Text(
                    'Support me on Ko-fi',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/channdara/revanced_manager_flutter',
                    );
                  },
                  dense: true,
                  title: const Text(
                    'This Project GitHub',
                    style: AppTextStyle.s14,
                  ),
                  trailing: const Icon(Icons.code_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

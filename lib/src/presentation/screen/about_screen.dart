import 'package:flutter/material.dart';

import '../../base/base_stateful_bloc.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsItemWidget(
              titleLabel: 'Credit To The Owner',
              children: [
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://ko-fi.com/rvmanager',
                    );
                  },
                  dense: true,
                  title: const Text('Support ReVanced on Ko-fi'),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/revancedapps/revancedmanager',
                    );
                  },
                  dense: true,
                  title: const Text('ReVanced Source Code'),
                  trailing: const Icon(Icons.code_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser('https://revanced.net');
                  },
                  dense: true,
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
                  dense: true,
                  title: const Text('Buy me a Coffee'),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://ko-fi.com/eamchanndara',
                    );
                  },
                  dense: true,
                  title: const Text('Support me on Ko-fi'),
                  trailing: const Icon(Icons.coffee_rounded),
                ),
                ListTile(
                  onTap: () {
                    bloc.openLinkInExternalBrowser(
                      'https://github.com/channdara/revanced_manager_flutter',
                    );
                  },
                  dense: true,
                  title: const Text('This Project Source Code'),
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

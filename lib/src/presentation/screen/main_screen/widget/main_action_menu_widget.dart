import 'package:flutter/material.dart';

import '../../about_screen.dart';
import '../../changelog_screen/changelog_screen.dart';
import '../../settings_screen/settings_screen.dart';

class MainActionMenuWidget extends StatelessWidget {
  const MainActionMenuWidget({super.key, required this.updateAvailable});

  final bool updateAvailable;

  static const double _iconSize = 20.0;
  static const Widget _widthSpacing = SizedBox(width: 16.0);
  static const EdgeInsets _itemPadding =
      EdgeInsets.only(left: 16.0, right: 32.0);

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 1.0,
      menuPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () {
              _push(context, const SettingsScreen());
            },
            padding: _itemPadding,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings_rounded, size: _iconSize),
                _widthSpacing,
                Text('Settings'),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              _push(context, const SettingsScreen(autoCheckUpdate: true));
            },
            padding: _itemPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.update_rounded, size: _iconSize),
                _widthSpacing,
                Text(updateAvailable ? 'Update Available' : 'Check Update'),
                if (updateAvailable) ...[
                  _widthSpacing,
                  const Icon(Icons.circle, size: 10.0, color: Colors.orange),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              _push(context, const ChangelogScreen());
            },
            padding: _itemPadding,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notes_rounded, size: _iconSize),
                _widthSpacing,
                Text('Changelog'),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              _push(context, const AboutScreen());
            },
            padding: _itemPadding,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_rounded, size: _iconSize),
                _widthSpacing,
                Text('About'),
              ],
            ),
          ),
        ];
      },
    );
  }
}

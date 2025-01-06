import 'package:flutter/material.dart';

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    super.key,
    required this.titleLabel,
    required this.children,
    this.trailingTitle,
  });

  final String titleLabel;
  final List<Widget> children;
  final Widget? trailingTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    titleLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                if (trailingTitle != null) trailingTitle!,
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

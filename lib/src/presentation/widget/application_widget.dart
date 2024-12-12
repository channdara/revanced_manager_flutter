import 'package:flutter/material.dart';

import '../../model/revanced_application.dart';
import 'application_actions_widget.dart';

class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({
    super.key,
    required this.application,
    required this.onReload,
  });

  final RevancedApplication application;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 86.0,
                  width: 86.0,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Image.network(
                    application.icon ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.appName ?? '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        application.appShortDescription ?? '',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ApplicationActionsWidget(
              application: application,
              onReload: onReload,
            ),
          ],
        ),
      ),
    );
  }
}

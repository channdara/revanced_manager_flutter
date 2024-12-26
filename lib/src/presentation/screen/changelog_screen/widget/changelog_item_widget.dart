import 'package:flutter/material.dart';

import '../../../../model/my_application.dart';

class ChangelogItemWidget extends StatelessWidget {
  const ChangelogItemWidget({
    super.key,
    required this.application,
    required this.isCurrent,
    required this.isLatest,
  });

  final MyApplication application;
  final bool isCurrent;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    application.tagName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                if (isLatest)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      'Latest',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                if (isCurrent)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(application.body),
          ],
        ),
      ),
    );
  }
}

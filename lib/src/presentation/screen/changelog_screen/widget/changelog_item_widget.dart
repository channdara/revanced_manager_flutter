import 'package:flutter/material.dart';

import '../../../../common/app_text_style.dart';
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
      margin: const EdgeInsets.only(bottom: 16.0),
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
                    style: AppTextStyle.s16Bold,
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
                    child: const Text('Latest', style: AppTextStyle.s12Green),
                  ),
                if (isCurrent)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text('Current', style: AppTextStyle.s12Blue),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(application.body, style: AppTextStyle.s14),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../common/app_text_style.dart';

void showClearCacheDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
              child: Text('Clear Cache', style: AppTextStyle.s18Bold),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                '\nAre you sure you want to clear cache? All downloaded file will be remove and you will need to re-download the same app version again.\n\nThis will not effect the installed ReVanced apps.',
                style: AppTextStyle.s14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Don't Clear", style: AppTextStyle.s14),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        onConfirm,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Yes Clear', style: AppTextStyle.s14),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

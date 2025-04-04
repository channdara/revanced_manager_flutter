import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/app_text_style.dart';
import '../../model/revanced_application.dart';

void showCancelDownloadingDialog(
  BuildContext context,
  RevancedApplication app,
  VoidCallback onConfirm,
) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cancel Downloading', style: AppTextStyle.s18Bold),
                  SizedBox(height: 8.0),
                  Text(
                    'Are you sure you want to cancel downloading the application below?',
                    style: AppTextStyle.s14,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: app.icon,
                fit: BoxFit.cover,
              ),
              title: Text(app.appName, style: AppTextStyle.s16Bold),
              subtitle: Text(
                app.appShortDescription,
                style: AppTextStyle.s10,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                    child: const Text('Reconsider', style: AppTextStyle.s14),
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
                    child: const Text('Cancel Now', style: AppTextStyle.s14),
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

import 'dart:async';

import 'package:flutter/material.dart';

import '../../manager/application_manager.dart';
import '../../manager/download_manager.dart';
import '../../model/revanced_application.dart';

class ApplicationActionsWidget extends StatefulWidget {
  const ApplicationActionsWidget({
    super.key,
    required this.application,
    required this.onReload,
  });

  final RevancedApplication application;
  final VoidCallback onReload;

  @override
  State<ApplicationActionsWidget> createState() =>
      _ApplicationActionsWidgetState();
}

class _ApplicationActionsWidgetState extends State<ApplicationActionsWidget> {
  Timer? _timer;
  bool _downloading = false;
  double _progress = 0.0;

  String get _packageName => widget.application.androidPackageName ?? '';

  void _startDownloadApplication() {
    _downloading = true;
    setState(() {});
    DownloadManager().downloadRevancedApplication(
      widget.application,
      (progress) {
        _progress = progress;
      },
    ).then((filePath) {
      if (filePath.isEmpty) return;
      _stopTimer();
      setState(() {});
      _installDownloadedApplication(filePath);
    });
    _startTimer();
  }

  void _installDownloadedApplication(String filePath) {
    ApplicationManager().install(filePath, onInstallComplete: (_) {
      widget.onReload();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_progress >= 1.0) _stopTimer();
      setState(() {});
    });
  }

  void _stopTimer() {
    _downloading = false;
    _progress = 0.0;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Installed: ${widget.application.installedVersionCode ?? 'N/A'}',
                style: const TextStyle(fontSize: 12.0),
              ),
              Text(
                'Latest: ${widget.application.latestVersionCode ?? 'N/A'}',
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        if (widget.application.updateAvailable)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.upload_rounded,
              color: Colors.green,
            ),
          ),
        if (true == widget.application.isInstalled)
          IconButton(
            onPressed: () {
              ApplicationManager().uninstall(_packageName).then((_) {
                widget.onReload();
              });
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
        if (true == widget.application.isInstalled)
          IconButton(
            onPressed: () {
              ApplicationManager().open(_packageName);
            },
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        if (true != widget.application.isInstalled)
          IconButton(
            onPressed: () {
              _startDownloadApplication();
            },
            icon: _downloading
                ? SizedBox.square(
                    dimension: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      value: _progress,
                    ),
                  )
                : const Icon(Icons.download_rounded),
          ),
      ],
    );
  }
}

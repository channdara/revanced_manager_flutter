import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../manager/api_manager.dart';
import '../../model/revanced_application.dart';
import '../widget/application_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _loading = true;
  List<RevancedApplication> _items = [];

  Future<void> _getRevancedApplications() async {
    try {
      final items = await ApiManager().getRevancedApplications();
      _loading = false;
      _items = items;
      setState(() {});
    } catch (_) {
      _loading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _getRevancedApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Revanced Manager'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(strokeWidth: 3.0),
            )
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _getRevancedApplications,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final application = _items[index];
                  return ApplicationWidget(
                    application: application,
                    onReload: () {
                      _refreshIndicatorKey.currentState?.show();
                    },
                  );
                },
              ),
            ),
    );
  }
}

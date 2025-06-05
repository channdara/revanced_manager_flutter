import 'package:flutter/material.dart';

import '../about_screen.dart';
import '../home_screen/home_screen.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Key _navigationBarKey = const Key('revanced_manager');
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        final number = DateTime.now().millisecondsSinceEpoch;
        _navigationBarKey = Key('revanced_manager_$number');
        _onDestinationSelected(0);
      },
      canPop: _selectedIndex == 0,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeScreen(),
            AboutScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          key: _navigationBarKey,
          onDestinationSelected: _onDestinationSelected,
          selectedIndex: _selectedIndex,
          maintainBottomViewPadding: true,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.android_rounded),
              label: 'Applications',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_rounded),
              label: 'About Us',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

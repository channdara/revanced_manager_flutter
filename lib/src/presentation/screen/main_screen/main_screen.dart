import 'package:flutter/material.dart';

import '../../../manager/callback_manager.dart';
import '../about_screen.dart';
import '../home_screen/bloc/home_bloc.dart';
import '../home_screen/home_screen.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (index == 2) CallbackManager().reloadSettingScreenCallback?.call();
    if (index == _selectedIndex) {
      if (index == 0 && homeScrollController.offset > 100.0) {
        homeScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        return;
      }
      return;
    }
    _selectedIndex = index;
    setState(() {});
  }

  @override
  void dispose() {
    homeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
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

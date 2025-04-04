import 'package:flutter/material.dart';

import '../../base/base_stateful.dart';
import '../../common/app_text_style.dart';
import 'main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStateful<SplashScreen> {
  @override
  void initStatePostFrameCallback() {
    super.initStatePostFrameCallback();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute<dynamic>(builder: (_) => const MainScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(32.0),
          child: Image.asset(
            'android/app/src/main/ic_launcher-playstore.png',
            width: MediaQuery.sizeOf(context).width / 3,
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
        height: kToolbarHeight,
        padding: EdgeInsets.zero,
        child: Center(
          child: Text(
            'This is not the original ReVanced Manager',
            style: AppTextStyle.s14,
          ),
        ),
      ),
    );
  }
}

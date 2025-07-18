import 'package:flutter/material.dart';

import '../../common/app_text_style.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.6,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/img_error.png',
            width: 100.0,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Oops! Something went wrong',
            style: AppTextStyle.s16Bold,
            textAlign: TextAlign.center,
          ),
          const Text(
            "We're unable to process your request right now. Please try again later...",
            style: AppTextStyle.s14,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

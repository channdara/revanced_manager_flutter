import 'package:flutter/material.dart';

import '../../common/app_text_style.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, this.padding});

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
            'assets/image/img_empty.png',
            width: 100.0,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Oops! No Result Found',
            style: AppTextStyle.s16Bold,
            textAlign: TextAlign.center,
          ),
          const Text(
            'Try update filter or refresh the list...',
            style: AppTextStyle.s14,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

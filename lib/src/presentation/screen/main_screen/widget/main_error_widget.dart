import 'package:flutter/material.dart';

class MainErrorWidget extends StatelessWidget {
  const MainErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.7,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/img_error.png',
            width: 150.0,
          ),
          const Text(
            'Oops! Something went wrong on our end',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            "We're unable to process your request right now.\nPlease try again by swipe down to refresh.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

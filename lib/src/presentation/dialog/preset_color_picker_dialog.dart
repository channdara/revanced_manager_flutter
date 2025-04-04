import 'package:flutter/material.dart';

import '../../common/app_text_style.dart';

Future<Color?> showPresetColorPickerDialog(BuildContext context) {
  return showDialog<Color>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Your Favorite Color',
                textAlign: TextAlign.center,
                style: AppTextStyle.s18Bold,
              ),
              const SizedBox(height: 32.0),
              Wrap(
                children: Colors.primaries.map((color) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(color);
                    },
                    icon: Icon(
                      Icons.circle,
                      color: color,
                      size: 40.0,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';

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
                'Choose your favorite color',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
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

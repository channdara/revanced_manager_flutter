import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class BaseStateful<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initStatePostFrameCallback();
    });
  }

  void initStatePostFrameCallback() {}
}

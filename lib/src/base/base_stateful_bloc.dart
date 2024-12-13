import 'package:flutter/material.dart';

import 'base_bloc.dart';
import 'base_bloc_state.dart';
import 'base_stateful.dart';

abstract class BaseStatefulBloc<T extends StatefulWidget, B extends BaseBloc>
    extends BaseStateful<T> {
  abstract B bloc;

  void setupObserver(BaseBlocState state) {}

  @override
  void initState() {
    super.initState();
    bloc.stream.listen((event) {
      setupObserver(event);
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    bloc.close();
    super.dispose();
  }
}

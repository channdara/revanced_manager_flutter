import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc_state.dart';

abstract class BaseBloc extends BlocBase<BaseBlocState> {
  BaseBloc() : super(AppBlocStateInit());

  bool isLoading = false;

  void dispose() {}

  void emitLoading() {
    if (isLoading) return;
    isLoading = true;
    safeEmit(AppBlocStateLoading());
  }

  void emitLoaded() {
    if (!isLoading) return;
    isLoading = false;
    safeEmit(AppBlocStateLoaded());
  }

  void emitEmpty() {
    safeEmit(AppBlocStateEmpty());
  }

  void emitError(dynamic exception) {
    safeEmit(AppBlocStateError());
  }

  void safeEmit(BaseBlocState state) {
    if (!isClosed) emit(state);
  }

  Future<void> execute({
    required Future<void> Function() requesting,
    void Function(dynamic exception)? onError,
  }) async {
    if (isLoading) return;
    try {
      await requesting();
    } catch (exception) {
      if (onError != null) {
        emitLoaded();
        onError(exception);
      } else {
        emitLoaded();
        emitError(exception);
      }
    }
  }

  BlocBuilder<BaseBloc, BaseBlocState> builder({
    required BlocWidgetBuilder<BaseBlocState> builder,
    BlocBuilderCondition<BaseBlocState>? buildWhen,
  }) {
    return BlocBuilder<BaseBloc, BaseBlocState>(
      bloc: this,
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

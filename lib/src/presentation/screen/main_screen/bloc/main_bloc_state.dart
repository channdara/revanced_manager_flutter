import '../../../../base/base_bloc_state.dart';
import '../../../../model/revanced_application.dart';

class MainStateGotData extends BaseBlocState {
  MainStateGotData(this.items);

  final List<RevancedApplication> items;
}

class MainStateDownload extends BaseBlocState {}

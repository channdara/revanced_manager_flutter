import '../../../../base/base_bloc_state.dart';
import '../../../../model/my_application.dart';

class ChangelogStateGotReleases extends BaseBlocState {
  ChangelogStateGotReleases(this.items);

  final List<MyApplication> items;
}

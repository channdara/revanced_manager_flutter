import 'package:flutter/material.dart';

import '../../../../common/app_text_style.dart';
import '../../../../model/revanced_application.dart';
import '../../../widget/cached_network_image_widget.dart';
import '../bloc/home_bloc.dart';
import 'home_item_action_widget.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({
    super.key,
    required this.bloc,
    required this.app,
  });

  final HomeBloc bloc;
  final RevancedApplication app;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                margin: const EdgeInsets.all(16.0),
                child: CachedNetworkImageWidget(imageUrl: app.icon),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.appName,
                        style: AppTextStyle.s16Bold,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        app.appShortDescription,
                        style: AppTextStyle.s12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'Installed: ${app.installedVersionCode}',
                    style: AppTextStyle.s12,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.arrow_right_alt_rounded),
                ),
                Flexible(
                  child: Text(
                    'Latest: ${app.latestVersionCode}',
                    style: AppTextStyle.s12,
                  ),
                ),
              ],
            ),
          ),
          HomeItemActionWidget(bloc: bloc, app: app),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_text_style.dart';
import '../../../../model/revanced_application.dart';
import '../bloc/main_bloc.dart';
import 'main_item_action_widget.dart';

class MainItemWidget extends StatelessWidget {
  const MainItemWidget({
    super.key,
    required this.bloc,
    required this.app,
  });

  final MainBloc bloc;
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
                height: 64.0,
                width: 64.0,
                margin: const EdgeInsets.all(16.0),
                child: CachedNetworkImage(
                  imageUrl: app.icon,
                  fit: BoxFit.cover,
                ),
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
                      const SizedBox(height: 4.0),
                      Text(
                        app.appShortDescription,
                        style: AppTextStyle.s12Grey,
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
          MainItemActionWidget(bloc: bloc, app: app),
        ],
      ),
    );
  }
}

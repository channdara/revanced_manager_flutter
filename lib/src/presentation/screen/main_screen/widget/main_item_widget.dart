import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../base/base_stateful_bloc.dart';
import '../../../../model/revanced_application.dart';
import '../bloc/main_item_bloc.dart';
import 'main_item_action_widget.dart';

class MainItemWidget extends StatefulWidget {
  const MainItemWidget({super.key, required this.app});

  final RevancedApplication app;

  @override
  State<MainItemWidget> createState() => _MainItemWidgetState();
}

class _MainItemWidgetState
    extends BaseStatefulBloc<MainItemWidget, MainItemBloc> {
  @override
  MainItemBloc bloc = MainItemBloc();

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
                height: 86.0,
                width: 86.0,
                margin: const EdgeInsets.all(16.0),
                child: CachedNetworkImage(
                  imageUrl: widget.app.icon ?? '',
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
                        widget.app.appName ?? '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.app.appShortDescription ?? '',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
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
                Text(
                  'Installed: ${widget.app.installedVersionCode ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12.0),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.arrow_right_alt_rounded),
                ),
                Text(
                  'Latest: ${widget.app.latestVersionCode ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
          MainItemActionWidget(
            bloc: bloc,
            app: widget.app,
          ),
        ],
      ),
    );
  }
}

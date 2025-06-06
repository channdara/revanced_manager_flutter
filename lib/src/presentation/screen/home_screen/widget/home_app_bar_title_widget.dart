import 'package:flutter/material.dart';

import '../../../../common/app_text_style.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_bloc_state.dart';

class HomeAppBarTitleWidget extends StatelessWidget {
  const HomeAppBarTitleWidget({super.key, required this.bloc});

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return bloc.builder(
      buildWhen: (p, c) => c is HomeStateSwitchAppBar,
      builder: (context, state) {
        return bloc.searchAppBar
            ? TextFormField(
                onChanged: bloc.onSearchTextChanged,
                style: AppTextStyle.s14,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondaryContainer,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  hintText: 'Find applications...',
                ),
              )
            : const Text('Revanced Manager');
      },
    );
  }
}

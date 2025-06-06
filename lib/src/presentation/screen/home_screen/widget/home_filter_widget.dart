import 'package:flutter/material.dart';

import '../../../../common/app_text_style.dart';
import '../../../../model/home_filter.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_bloc_state.dart';

class HomeFilterWidget extends StatelessWidget {
  const HomeFilterWidget({super.key, required this.bloc});

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: 16.0,
          bottom: 8.0,
          right: 8.0,
        ),
        child: Row(
          children: HomeFilter.values.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: bloc.builder(
                buildWhen: (p, c) => c is HomeStateGotData,
                builder: (context, state) {
                  final showBadge = filter == HomeFilter.UPDATE &&
                      bloc.updateAvailableCount > 0;
                  return ChoiceChip(
                    onSelected: (selected) {
                      bloc.onChoiceChipSelected(filter);
                    },
                    label: Row(
                      children: [
                        Text(filter.label),
                        if (showBadge)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              bloc.updateAvailableCount.toString(),
                              style: AppTextStyle.s12BoldGreen,
                            ),
                          ),
                      ],
                    ),
                    selected: filter == bloc.selectedFilter,
                    labelStyle: AppTextStyle.s12,
                    showCheckmark: false,
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

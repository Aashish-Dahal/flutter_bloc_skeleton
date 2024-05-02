import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/common/bloc/pagination_bloc.dart';
import '../atoms/circular_loading_indicator.dart';
import '../molecules/refresh_list_view.dart';

class BlocPaginationView<T> extends StatelessWidget {
  final Widget Function(T) itemBuilder;
  final bool showDivider;

  const BlocPaginationView({
    super.key,
    required this.itemBuilder,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationBloc, PaginationState>(
      builder: (context, state) {
        switch (state) {
          case PaginationLoading():
            return const CircularLoadingIndicator(
              scale: 1,
            );
          case PaginationSuccess():
            return RefreshListView(
              showDivider: showDivider,
              controller: context.read<PaginationBloc>().scrollController,
              onRefresh: () async {
                context.read<PaginationBloc>().add(PaginationRefresh());
              },
              itemCount: context.read<PaginationBloc>().hasReachedMax
                  ? state.data.length
                  : state.data.length + 1,
              itemBuilder: (_, i) {
                return (i >= state.data.length)
                    ? const CircularLoadingIndicator()
                    : itemBuilder(state.data[i] as T);
              },
            );
          case PaginationError():
            return Center(
              child: Text(state.error as String),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

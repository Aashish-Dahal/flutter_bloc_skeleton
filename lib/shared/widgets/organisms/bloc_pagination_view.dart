import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum/index.dart';
import '../../bloc/base_pagination_bloc.dart';
import '../atoms/circular_loading_indicator.dart';
import '../molecules/refresh_list_view.dart';

class BlocPaginationView<T, B extends BasePaginationBloc<T>>
    extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? loadingIndicator;
  final Widget? emptyView;
  final Widget? errorView;
  final bool showDivider;
  final EdgeInsets? padding;
  final double scrollThreshold;

  const BlocPaginationView({
    super.key,
    required this.itemBuilder,
    this.loadingIndicator,
    this.emptyView,
    this.errorView,
    this.showDivider = true,
    this.padding,
    this.scrollThreshold = 0.9,
  });

  @override
  State<BlocPaginationView<T, B>> createState() =>
      _BlocPaginationViewState<T, B>();
}

class _BlocPaginationViewState<T, B extends BasePaginationBloc<T>>
    extends State<BlocPaginationView<T, B>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * widget.scrollThreshold)) {
      final bloc = context.read<B>();
      if (!bloc.state.hasReachedMax &&
          bloc.state.status != PaginationStatus.loading) {
        bloc.add(const PaginationFetch());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, PaginationState<T>>(
      builder: (context, state) {
        if (state.status == PaginationStatus.initial ||
            (state.status == PaginationStatus.loading && state.data.isEmpty)) {
          return widget.loadingIndicator ??
              const Center(child: CircularLoadingIndicator());
        }

        if (state.status == PaginationStatus.failure && state.data.isEmpty) {
          return widget.errorView ??
              Center(child: Text(state.error ?? 'An error occurred'));
        }

        if (state.data.isEmpty) {
          return widget.emptyView ?? const Center(child: Text('No data found'));
        }

        return RefreshListView(
          controller: _scrollController,
          padding: widget.padding,
          showDivider: widget.showDivider,
          onRefresh: () async {
            context.read<B>().add(const PaginationRefresh());
          },
          itemCount: state.hasReachedMax
              ? state.data.length
              : state.data.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.data.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularLoadingIndicator(),
              );
            }
            return widget.itemBuilder(context, state.data[index]);
          },
        );
      },
    );
  }
}

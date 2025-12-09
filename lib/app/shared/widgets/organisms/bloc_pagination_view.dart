import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum/index.dart';
import '../../../core/utils/typedf/index.dart';
import '../../bloc/pagination_bloc.dart';
import '../atoms/circular_loading_indicator.dart';
import '../molecules/refresh_list_view.dart';

class BlocPaginationView<T> extends StatefulWidget {
  final FutureCall call;
  final PaginationType type;

  final Widget Function(T) itemBuilder;
  final bool showDivider;

  const BlocPaginationView({
    super.key,
    required this.itemBuilder,
    this.showDivider = true,
    required this.call,
    this.type = PaginationType.cursor,
  });

  @override
  State<BlocPaginationView<T>> createState() => _BlocPaginationViewState<T>();
}

class _BlocPaginationViewState<T> extends State<BlocPaginationView<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => PaginationBloc(
            widget.call,
            type: widget.type,
            scrollController: _scrollController,
          ),
      child: BlocBuilder<PaginationBloc, PaginationState>(
        builder: (context, state) {
          switch (state) {
            case PaginationLoading():
              return const CircularLoadingIndicator(scale: 1);
            case PaginationSuccess():
              return RefreshListView(
                showDivider: widget.showDivider,
                controller: _scrollController,
                onRefresh: () async {
                  context.read<PaginationBloc>().add(PaginationRefresh());
                },
                itemCount:
                    context.read<PaginationBloc>().hasReachedMax
                        ? state.data.length
                        : state.data.length + 1,
                itemBuilder: (_, i) {
                  return (i >= state.data.length)
                      ? const CircularLoadingIndicator()
                      : widget.itemBuilder(state.data[i] as T);
                },
              );
            case PaginationError():
              return Center(child: Text(state.error as String));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

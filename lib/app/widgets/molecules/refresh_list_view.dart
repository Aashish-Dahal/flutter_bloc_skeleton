import 'package:flutter/material.dart';

class RefreshListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final bool showDivider;

  const RefreshListView({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: controller,
        itemBuilder: itemBuilder,
        separatorBuilder: (_, i) =>
            showDivider ? const Divider() : const SizedBox(),
        itemCount: itemCount,
      ),
    );
  }
}

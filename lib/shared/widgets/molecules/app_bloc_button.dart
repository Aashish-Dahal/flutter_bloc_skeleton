import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum/index.dart';
import '../atoms/app_button.dart';

/// A generic BLoC-aware button molecule.
/// [B] is the Bloc type, [S] is the State type.
class AppBlocButton<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B bloc;
  final String label;
  final ButtonVariant variant;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;

  final void Function(BuildContext context, S state) listener;
  final void Function(B bloc) onTap;
  final bool Function(S state) isLoading;
  final bool Function(S state)? isDisabled;

  const AppBlocButton({
    super.key,
    required this.bloc,
    required this.label,
    required this.onTap,
    required this.listener,
    required this.isLoading,
    this.isDisabled,
    this.variant = ButtonVariant.elevated,
    this.icon,
    this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<B, S>(
        listener: listener,
        builder: (context, state) {
          final loading = isLoading(state);
          return AppButton(
            label: label,
            variant: variant,
            color: color,
            isFullWidth: isFullWidth,
            onPressed: () => onTap(bloc),
            loading: loading,
            icon: icon,
          );
        },
      ),
    );
  }
}

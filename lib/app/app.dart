import 'package:easy_localization/easy_localization.dart'
    show BuildContextEasyLocalizationExtension;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BuildContext, MaterialApp, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import 'config/routes/app_routes.dart'
    show AppRouter;
import 'config/theme/app_theme.dart' show AppTheme;
import 'injector.dart';
import 'pages/auth/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: getIt<AuthBloc>())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: kDebugMode,
        routerConfig: AppRouter(getIt<AuthBloc>()).router,
        title: 'Flutter Bloc Skeleton',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: [...context.localizationDelegates],
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}

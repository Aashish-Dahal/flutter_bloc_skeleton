import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BuildContext, MaterialApp, Size, StatelessWidget, ThemeData, Widget;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, MultiBlocProvider;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/service_locator.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<AppTheme>()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(360, 690),
        builder: (context, child) => BlocBuilder<AppTheme, ThemeData>(
          builder: (context, themeData) => MaterialApp.router(
            debugShowCheckedModeBanner: kDebugMode,
            routerConfig: AppRouter(sl<AuthBloc>()).router,
            title: 'Flutter Bloc Skeleton',
            theme: themeData,
            localizationsDelegates: [...context.localizationDelegates],
            supportedLocales: context.supportedLocales,
          ),
        ),
      ),
    );
  }
}

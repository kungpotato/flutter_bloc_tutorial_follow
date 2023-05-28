import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/app/locator.dart';
import 'package:fluttertodo/authentication/bloc/authentication_bloc.dart';
import 'package:fluttertodo/authentication/view/splash_page.dart';
import 'package:fluttertodo/home_page.dart';
import 'package:fluttertodo/l10n/l10n.dart';
import 'package:fluttertodo/login/login.dart';
import 'package:fluttertodo/theme/cubit/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

final getIt = GetIt.instance;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    locatorSetup();
  }

  @override
  void dispose() {
    getIt<AuthenticationRepository>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (context) => getIt(),
          ),
          RepositoryProvider<UserRepository>(
            create: (context) => getIt(),
          ),
          RepositoryProvider<WeatherRepository>(
            create: (context) => getIt(),
          ),
          RepositoryProvider<TodosRepository>(
            create: (context) => getIt(),
          ),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: getIt<AuthenticationRepository>(),
              userRepository: getIt<UserRepository>(),
            ),
          ),
          BlocProvider(create: (_) => ThemeCubit())
        ], child: const AppView()));
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ThemeCubit, Color>(
        builder: (context, color) => MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                primaryColor: color,
                textTheme: GoogleFonts.rajdhaniTextTheme(),
                appBarTheme: AppBarTheme(
                    titleTextStyle: GoogleFonts.rajdhaniTextTheme(textTheme)
                        .apply(bodyColor: Colors.white)
                        .titleLarge,
                    color: color),
              ),
              navigatorKey: _navigatorKey,
              builder: (context, child) {
                return BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case AuthenticationStatus.authenticated:
                        _navigator.pushAndRemoveUntil<void>(
                          HomePage.route(),
                          (route) => false,
                        );
                        break;
                      case AuthenticationStatus.unauthenticated:
                        _navigator.pushAndRemoveUntil<void>(
                          LoginPage.route(),
                          (route) => false,
                        );
                        break;
                      case AuthenticationStatus.unknown:
                        break;
                    }
                  },
                  child: child,
                );
              },
              onGenerateRoute: (_) => SplashPage.route(),
            ));
  }
}

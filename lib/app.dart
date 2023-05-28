import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/home_page.dart';
import 'package:fluttertodo/theme/cubit/theme_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'authentication/view/splash_page.dart';
import 'login/login.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final WeatherRepository _weatherRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
    _weatherRepository = WeatherRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authenticationRepository),
          RepositoryProvider.value(value: _weatherRepository)
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
                authenticationRepository: _authenticationRepository,
                userRepository: _userRepository),
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
                      case AuthenticationStatus.unauthenticated:
                        _navigator.pushAndRemoveUntil<void>(
                          LoginPage.route(),
                          (route) => false,
                        );
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

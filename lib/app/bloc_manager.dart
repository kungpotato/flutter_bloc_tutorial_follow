import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/app/locator.dart';
import 'package:fluttertodo/authentication/bloc/authentication_bloc.dart';
import 'package:fluttertodo/theme/cubit/theme_cubit.dart';
import 'package:user_repository/user_repository.dart';

class BlocManager {
  static final BlocManager _instance = BlocManager._internal();

  factory BlocManager() {
    return _instance;
  }

  BlocManager._internal();

  static final themeCubit = ThemeCubit();
  static final authBloc = AuthenticationBloc(
      authenticationRepository: getIt<AuthenticationRepository>(),
      userRepository: getIt<UserRepository>());

  List<BlocProvider> get blocProviders {
    return [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      BlocProvider<AuthenticationBloc>(create: (_) => authBloc),
    ];
  }

  static void dispose() {
    themeCubit.close();
    authBloc.close();
  }
}

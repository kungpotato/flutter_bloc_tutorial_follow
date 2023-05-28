import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/app/locator.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

class RepositoryManager {
  static final RepositoryManager _instance = RepositoryManager._internal();

  factory RepositoryManager() {
    return _instance;
  }

  RepositoryManager._internal();

  void setup() {
    locatorSetup();
  }

  void dispose() {
    getIt<AuthenticationRepository>().dispose();
  }

  List<RepositoryProvider> get repositories {
    return [
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
    ];
  }
}

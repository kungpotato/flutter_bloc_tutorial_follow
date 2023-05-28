import 'package:authentication_repository/authentication_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

final getIt = GetIt.instance;

void locatorSetup() async {
  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<WeatherRepository>(() => WeatherRepository());

  final todoPlugin = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<TodosRepository>(() =>
      TodosRepository(todosApi: LocalStorageTodosApi(plugin: todoPlugin)));
}

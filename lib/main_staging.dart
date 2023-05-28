import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/simple_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'counter_observer.dart';

void main() async {
  runZonedGuarded(
    () async {
      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );

      Bloc.observer = const CounterObserver();
      Bloc.observer = const SimpleBlocObserver();
      // Bloc.observer = const AppBlocObserver();

      // final todosRepository = TodosRepository(todosApi: todosApi);
      BindingBase.debugZoneErrorsAreFatal = true;
      WidgetsFlutterBinding.ensureInitialized();

      return const App();
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

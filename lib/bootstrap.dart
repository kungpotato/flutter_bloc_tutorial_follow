import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/app/app.dart';
import 'package:fluttertodo/counter_observer.dart';
import 'package:fluttertodo/simple_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void bootstrap() async {
  runZonedGuarded(
    () async {
      BindingBase.debugZoneErrorsAreFatal = false;
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getTemporaryDirectory(),
      );

      Bloc.observer = const CounterObserver();
      Bloc.observer = const SimpleBlocObserver();

      return runApp(const App());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

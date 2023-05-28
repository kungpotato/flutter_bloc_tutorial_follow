import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/app.dart';
import 'package:fluttertodo/counter_observer.dart';
import 'package:fluttertodo/simple_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const CounterObserver();
  Bloc.observer = const SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(const App());
}

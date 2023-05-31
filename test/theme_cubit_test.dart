import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertodo/theme/cubit/theme_cubit.dart';
import 'package:fluttertodo/weather/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

// ignore: must_be_immutable
class MockWeather extends Mock implements Weather {
  MockWeather(this._condition);

  final weather_repository.WeatherCondition _condition;

  @override
  weather_repository.WeatherCondition get condition => _condition;
}

void main() {
  group('ThemeCubit', () {
    late ThemeCubit themeCubit;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory: await getTemporaryDirectory());
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('initial state is correct', () {
      expect(themeCubit.state, ThemeCubit.defaultColor);
    });

    group('toJson/fromJson', () {
      test('work properly', () {
        final themeCubit = ThemeCubit();
        expect(
          themeCubit.fromJson(themeCubit.toJson(themeCubit.state)),
          themeCubit.state,
        );
      });
    });

    blocTest<ThemeCubit, Color>(
      'emits new color when updateTheme(Weather) is called',
      build: () => themeCubit,
      act: (cubit) => cubit
          .updateTheme(MockWeather(weather_repository.WeatherCondition.clear)),
      expect: () => [
        Colors.orangeAccent,
      ],
    );

    group('updateTheme', () {
      final clearWeather =
          MockWeather(weather_repository.WeatherCondition.clear);
      final snowyWeather =
          MockWeather(weather_repository.WeatherCondition.snowy);
      final cloudyWeather =
          MockWeather(weather_repository.WeatherCondition.cloudy);
      final rainyWeather =
          MockWeather(weather_repository.WeatherCondition.rainy);
      final unknownWeather =
          MockWeather(weather_repository.WeatherCondition.unknown);

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.clear',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(clearWeather),
        expect: () => <Color>[Colors.orangeAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.snowy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(snowyWeather),
        expect: () => <Color>[Colors.lightBlueAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.cloudy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(cloudyWeather),
        expect: () => <Color>[Colors.blueGrey],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.rainy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(rainyWeather),
        expect: () => <Color>[Colors.indigoAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.unknown',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(unknownWeather),
        expect: () => <Color>[ThemeCubit.defaultColor],
      );
    });
  });
}

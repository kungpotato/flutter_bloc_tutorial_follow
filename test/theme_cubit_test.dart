import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertodo/theme/cubit/theme_cubit.dart';
import 'package:fluttertodo/weather/models/models.dart';
import 'package:mocktail/mocktail.dart';
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
  // initHydratedStorage();

  group('ThemeCubit', () {
    test('initial state is correct', () {
      expect(ThemeCubit().state, ThemeCubit.defaultColor);
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

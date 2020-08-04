
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ft_bloc_weather/blocs/blocs.dart';
import 'package:ft_bloc_weather/repositories/repositories.dart';
import 'package:ft_bloc_weather/simple_bloc_observer.dart';
import 'package:http/http.dart' as http;

import 'package:ft_bloc_weather/widgets/widgets.dart';

void main() {
  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
    ),
  );

  Bloc.observer = SimpleBlocObserver();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: App(weatherRepository: weatherRepository),
  ));
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  App({Key key, @required this.weatherRepository}) :
    assert(weatherRepository != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Bloc Weather',
          home: SafeArea(
            minimum: const EdgeInsets.all(8.0),
            child: BlocProvider(
              create: (context) =>
                  WeatherBloc(weatherRepository: weatherRepository),
              child: Weather(),
            ),
          ),
        );
      }
    );
  }
}



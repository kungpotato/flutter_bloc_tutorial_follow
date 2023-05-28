import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodo/counter/view/counter_page.dart';
import 'package:fluttertodo/posts/view/posts_page.dart';
import 'package:fluttertodo/timer/view/timer_page.dart';
import 'package:fluttertodo/weather/weather_page.dart';

import 'authentication/bloc/authentication_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดสอบ'),
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Counter'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CounterPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text('Timer'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimerPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text('Post'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostsPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text('WeatherPage'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeatherPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

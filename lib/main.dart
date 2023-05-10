import 'package:app_fiman/blocs/auth/auth_bloc.dart';
import 'package:app_fiman/blocs/create/create_bloc.dart';
import 'package:app_fiman/blocs/history/history_bloc.dart';
import 'package:app_fiman/views/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'blocs/history_filter/history_filter_bloc.dart';
import 'blocs/news/news_bloc.dart';
import 'blocs/notification/notification_bloc.dart';
import 'blocs/notification_screen/notification_screen_bloc.dart';
import 'blocs/resume/resume_bloc.dart';
import 'blocs/schedule/schedule_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  await initializeDateFormatting('id_ID', null).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => CreateBloc(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(),
        ),
        BlocProvider(
          create: (context) => HistoryFilterBloc(),
        ),
        BlocProvider(
          create: (context) => NewsBloc(),
        ),
        BlocProvider(
          create: (context) => ScheduleBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationScreenBloc(),
        ),
        BlocProvider(
          create: (context) => ResumeBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartScreen(),
      ),
    );
  }
}

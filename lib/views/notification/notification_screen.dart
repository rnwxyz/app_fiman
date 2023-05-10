import 'package:app_fiman/views/notification/add_schedule_screen.dart';
import 'package:app_fiman/views/notification/list_notif_screen.dart';
import 'package:app_fiman/views/notification/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notification_screen/notification_screen_bloc.dart';
import '../../utils/constants/contant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final pageController = PageController();
  bool isVisible = true;

  void changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi", style: headline2),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: black,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/notif.png",
                width: 300,
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<NotificationScreenBloc, NotificationScreenState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          changePage(0);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              state is NotificationScreenChanged
                                  ? state.colorNotif
                                  : accent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text("Notifikasi"),
                      );
                    },
                  ),
                  const SizedBox(width: 60),
                  BlocBuilder<NotificationScreenBloc, NotificationScreenState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          changePage(1);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              state is NotificationScreenChanged
                                  ? state.colorSchedule
                                  : accent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text("  Jadwal  "),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    Container(
                      color: secondary,
                      height: double.infinity,
                      width: double.infinity,
                      child: const ListNotifScreen(),
                    ),
                    Container(
                      color: secondary,
                      height: double.infinity,
                      width: double.infinity,
                      child: const ScheduleScreen(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const AddScheduleScreen();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final tween = Tween(begin: 0.1, end: 1.0);
                  return FadeTransition(
                    opacity: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

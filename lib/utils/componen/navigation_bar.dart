import 'package:flutter/material.dart';

import '../../views/home/home_screen.dart';
import '../../views/transaction/create_screen.dart';
import '../../views/transaction/history_screen.dart';
import '../constants/contant.dart';

class MyNavigationBar extends StatelessWidget {
  final int currentTab;
  const MyNavigationBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: secondary,
      selectedItemColor: primary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: primary,
            child: Icon(Icons.add),
          ),
          label: 'Tambah',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
      ],
      currentIndex: currentTab,
      onTap: (value) {
        if (value == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const HomeScreen();
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
        }
        if (value == 1) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const CreateScreen();
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
        }
        if (value == 2) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const HistoryScreen();
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
        }
      },
    );
  }
}

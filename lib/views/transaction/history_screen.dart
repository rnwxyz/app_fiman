import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/views/home/home_screen.dart';
import 'package:app_fiman/views/transaction/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/history/history_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    context.read<HistoryBloc>().add(HistoryFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Ini riwayat bre !', style: headline2),
              BlocConsumer<HistoryBloc, HistoryState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is HistoryInitial) {
                    return const CircularProgressIndicator();
                  } else if (state is HistorySuccess) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.transactionModels.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              leading:
                                  state.transactionModels[index].category ==
                                          pemasukanId
                                      ? const Icon(Icons.arrow_downward,
                                          color: Colors.green)
                                      : const Icon(Icons.arrow_upward,
                                          color: Colors.red),
                              title: Text(state.transactionModels[index].name),
                              subtitle: Text(state
                                  .transactionModels[index].amount
                                  .toString()),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is HistoryError) {
                    return Text(state.message);
                  } else {
                    return const Text('Error');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondary,
        selectedItemColor: primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
        currentIndex: 1,
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: primary,
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

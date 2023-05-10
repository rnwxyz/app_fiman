import 'package:app_fiman/utils/constants/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/notification_screen/notification_screen_bloc.dart';
import '../../blocs/schedule/schedule_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    context.read<NotificationScreenBloc>().add(NotificationScreenChangePage(1));
    context.read<ScheduleBloc>().add(ScheduleFeatch());
    super.initState();
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content: const Text('Apakah anda yakin ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                context.read<ScheduleBloc>().add(ScheduleDelete(id));
                Navigator.of(context).pop();
              },
              child: BlocConsumer<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Ya');
                  }
                },
                listener: (context, state) {
                  if (state is ScheduleError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ScheduleEmpty) {
          return const Center(
            child: Text('Tidak ada jadwal'),
          );
        } else if (state is ScheduleLoaded) {
          final schedules = state.schedules;
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final year = schedules[index].year;
              final month = schedules[index].month;
              final day = schedules[index].day;
              final String date;
              final Icon leading;

              if (year == null && month == null && day == null) {
                date = 'hari';
              } else if (year == null && month == null) {
                date = DateFormat('dd').format(DateTime(0, 0, day!));
              } else if (year == null) {
                date = DateFormat('dd MMMM', 'id_ID')
                    .format(DateTime(0, month!, day!));
              } else {
                date = DateFormat('dd MMMM yyyy')
                    .format(DateTime(year, month!, day!));
              }

              if (schedules[index].category == pemasukanId) {
                leading = const Icon(
                  Icons.arrow_circle_down_sharp,
                  size: 50,
                  color: success,
                );
              } else {
                leading = const Icon(
                  Icons.arrow_circle_up_sharp,
                  size: 50,
                  color: danger,
                );
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: leading,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.schedules[index].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          date == 'hari'
                              ? 'Setiap $date'
                              : 'Setiap Tanggal $date',
                          style: headline3,
                        ),
                        const SizedBox(height: 5),
                        Text(
                            state.schedules[index].amount > 9999999999
                                ? NumberFormat.compactCurrency(
                                        locale: 'id', symbol: 'Rp.')
                                    .format(state.schedules[index].amount)
                                : NumberFormat.currency(
                                        locale: 'id', symbol: 'Rp.')
                                    .format(state.schedules[index].amount),
                            style:
                                const TextStyle(fontSize: 17, color: primary)),
                        const SizedBox(height: 10),
                      ],
                    ),
                    subtitle: Text(
                      'KETERANGAN: ${state.schedules[index].description ?? ''}',
                      maxLines: 3,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _delete(state.schedules[index].id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

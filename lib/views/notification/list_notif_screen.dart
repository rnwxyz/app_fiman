import 'package:app_fiman/blocs/create/create_bloc.dart';
import 'package:app_fiman/models/schedule_model.dart';
import 'package:app_fiman/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification_screen/notification_screen_bloc.dart';
import '../../utils/constants/contant.dart';

class ListNotifScreen extends StatefulWidget {
  const ListNotifScreen({super.key});

  @override
  State<ListNotifScreen> createState() => _ListNotifScreenState();
}

class _ListNotifScreenState extends State<ListNotifScreen> {
  @override
  void initState() {
    context.read<NotificationScreenBloc>().add(NotificationScreenChangePage(0));
    context.read<NotificationBloc>().add(NotificationFeatch());
    super.initState();
  }

  void _autoCreateTransaction(ScheduleModel data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Transaksi'),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Apakah anda yakin ingin menambah ?'),
                const SizedBox(height: 10),
                Text('Nama : ${data.name}'),
                Text(
                    'Jumlah : ${data.amount > 9999999999 ? NumberFormat.compactCurrency(locale: 'id', symbol: 'Rp.').format(data.amount) : NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(data.amount)}'),
                Text('Kategori : ${data.categoryName}'),
                Text('Keterangan: ${data.description}', maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                final transaction = TransactionModel(
                    name: data.name,
                    amount: data.amount,
                    date: DateTime.now(),
                    category: data.category,
                    description: data.description);
                context.read<CreateBloc>().add(CreateSubmitEvent(transaction));
                context
                    .read<NotificationBloc>()
                    .add(NotificationRead(data.id!));
                Navigator.of(context).pop();
              },
              child: BlocConsumer<CreateBloc, CreateState>(
                builder: (context, state) {
                  if (state is CreateLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Ya');
                  }
                },
                listener: (context, state) {
                  if (state is CreateError) {
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
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NotificationEmpty) {
          return const Center(
            child: Text('Tidak ada notifikasi'),
          );
        } else if (state is NotificationLoaded) {
          final schedules = state.schedules;
          return ListView.builder(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final Icon leading;

              if (schedules[index].category == pemasukanId) {
                leading = const Icon(
                  Icons.arrow_circle_down_sharp,
                  size: 40,
                  color: success,
                );
              } else {
                leading = const Icon(
                  Icons.arrow_circle_up_sharp,
                  size: 40,
                  color: danger,
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      _autoCreateTransaction(schedules[index]);
                    },
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
                    trailing: const Icon(
                      Icons.notifications,
                      color: primary,
                      size: 40,
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

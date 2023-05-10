import 'dart:io';

import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/utils/componen/navigation_bar.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/history/history_bloc.dart';
import '../../blocs/history_filter/history_filter_bloc.dart';

class DetailHistoryScreen extends StatefulWidget {
  final TransactionModel transactionData;
  const DetailHistoryScreen({super.key, required this.transactionData});

  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  @override
  void initState() {
    context.read<HistoryFilterBloc>().add(HistoryFilterInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.transactionData;
    final defirence = DateTime.now().difference(data.date).inDays + 1;
    final String defirenceText;
    final Icon leading;
    final String nilai;

    if (defirence > 0) {
      defirenceText = '$defirence hari yang lalu';
    } else if (defirence < 0) {
      defirenceText = '${(defirence - 1) * -1} hari lagi';
    } else {
      defirenceText = 'Hari ini';
    }

    if (data.category == pemasukanId) {
      leading = const Icon(
        Icons.arrow_circle_down_sharp,
        size: 70,
        color: success,
      );
    } else {
      leading = const Icon(
        Icons.arrow_circle_up_sharp,
        size: 70,
        color: danger,
      );
    }

    nilai =
        NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(data.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail", style: headline2),
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
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/riwayat.png',
                    width: 150,
                  ),
                  const Text('Riwayat Transaksi', style: headline2),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: leading,
                        title: Text(
                          data.name,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        subtitle: Text(
                          defirenceText,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: primary),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text('Total ${data.categoryName}'.toUpperCase(),
                          style: button2),
                      const SizedBox(height: 10),
                      Text(
                        nilai,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondary,
                          // add shadow effects here
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                      .format(data.date),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: black),
                                ),
                                const SizedBox(height: 50),
                                const Text('KETERANGAN', style: button2),
                                const SizedBox(height: 20),
                                TextFormField(
                                  initialValue: data.description,
                                  readOnly: true,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: white,
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

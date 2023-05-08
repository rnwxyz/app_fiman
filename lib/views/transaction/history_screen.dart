import 'dart:io';

import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/utils/componen/navigation_bar.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/views/transaction/detail_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/history/history_bloc.dart';
import '../../blocs/history_filter/history_filter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  List<TransactionModel> transactionData = [];
  String sort = '';
  int categoryId = 0;

  @override
  void initState() {
    context.read<HistoryFilterBloc>().add(HistoryFilterInitialEvent());
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          context.read<HistoryBloc>().add(HistoryFetchEvent(
              loadMore: true,
              search: searchController.text,
              sort: sort,
              categoryId: categoryId));
        }
      },
    );
    context
        .read<HistoryBloc>()
        .add(HistoryFetchEvent(loadMore: false, search: ''));
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
                context.read<HistoryBloc>().add(HistoryDeleteEvent(id));
                Navigator.of(context).pop();
              },
              child: BlocConsumer<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Ya');
                  }
                },
                listener: (context, state) {
                  if (state is HistoryError) {
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<HistoryBloc>().add(HistoryFetchEvent(
                        loadMore: false,
                        search: searchController.text,
                        sort: sort,
                        categoryId: categoryId));
                  },
                ),
              ),
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
                decoration: const BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8, left: 27, bottom: 20, top: 15),
                  child: Row(
                    children: [
                      BlocConsumer<HistoryFilterBloc, HistoryFilterState>(
                        listener: (context, state) {
                          if (state is HistoryFilterSuccess) {
                            sort = state.sort;
                            categoryId = state.categoryId;
                          }
                        },
                        builder: (context, state) {
                          if (state is HistoryFilterSuccess) {
                            return GestureDetector(
                              onTap: () {
                                if (state.sort == '') {
                                  context
                                      .read<HistoryFilterBloc>()
                                      .add(HistoryFilterSortEvent('DESC'));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: 'DESC',
                                          categoryId: categoryId));
                                } else if (state.sort == 'DESC') {
                                  context
                                      .read<HistoryFilterBloc>()
                                      .add(HistoryFilterSortEvent('ASC'));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: 'ASC',
                                          categoryId: categoryId));
                                } else {
                                  context
                                      .read<HistoryFilterBloc>()
                                      .add(HistoryFilterSortEvent(''));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: '',
                                          categoryId: categoryId));
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: state.sort == 'ASC'
                                      ? const Icon(
                                          Icons.arrow_downward,
                                          color: white,
                                        )
                                      : state.sort == 'DESC'
                                          ? const Icon(
                                              Icons.arrow_upward,
                                              color: white,
                                            )
                                          : const Icon(
                                              Icons.notes_outlined,
                                              color: white,
                                            ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      BlocBuilder<HistoryFilterBloc, HistoryFilterState>(
                        builder: (context, state) {
                          if (state is HistoryFilterSuccess) {
                            return GestureDetector(
                              onTap: () {
                                if (state.categoryId == pemasukanId) {
                                  context
                                      .read<HistoryFilterBloc>()
                                      .add(HistoryFilterCategoryEvent(0));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: sort,
                                          categoryId: 0));
                                } else {
                                  context.read<HistoryFilterBloc>().add(
                                      HistoryFilterCategoryEvent(pemasukanId));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: sort,
                                          categoryId: pemasukanId));
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: state.categoryId == pemasukanId
                                      ? success
                                      : white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: state.categoryId == pemasukanId
                                          ? success
                                          : accent),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text("pemasukan",
                                      style: state.categoryId == pemasukanId
                                          ? headline4
                                          : headline3),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      BlocBuilder<HistoryFilterBloc, HistoryFilterState>(
                        builder: (context, state) {
                          if (state is HistoryFilterSuccess) {
                            return GestureDetector(
                              onTap: () {
                                if (state.categoryId == pengeluaranId) {
                                  context
                                      .read<HistoryFilterBloc>()
                                      .add(HistoryFilterCategoryEvent(0));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: sort,
                                          categoryId: 0));
                                } else {
                                  context.read<HistoryFilterBloc>().add(
                                      HistoryFilterCategoryEvent(
                                          pengeluaranId));
                                  context.read<HistoryBloc>().add(
                                      HistoryFetchEvent(
                                          loadMore: false,
                                          search: searchController.text,
                                          sort: sort,
                                          categoryId: pengeluaranId));
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: state.categoryId == pengeluaranId
                                      ? danger
                                      : white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: state.categoryId == pengeluaranId
                                          ? danger
                                          : accent),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text("pengeluaran",
                                      style: state.categoryId == pengeluaranId
                                          ? headline4
                                          : headline3),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              BlocConsumer<HistoryBloc, HistoryState>(
                listener: (context, state) {
                  if (state is HistorySuccess) {
                    transactionData = state.transactionModels;
                  }
                },
                builder: (context, state) {
                  if (state is HistoryInitial) {
                    return const CircularProgressIndicator();
                  } else if (state is HistoryError) {
                    return Text(state.message);
                  } else {
                    return Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: secondary,
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state is HistoryLoading
                              ? transactionData.length + 1
                              : transactionData.length,
                          itemBuilder: (context, index) {
                            if (index == transactionData.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Card(
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: transactionData[index].category ==
                                              pemasukanId
                                          ? success
                                          : danger,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text(
                                            DateFormat('dd', 'id_ID').format(
                                                transactionData[index].date),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM', 'id_ID').format(
                                                transactionData[index].date),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return DetailHistoryScreen(
                                              transactionData:
                                                  transactionData[index]);
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          final tween =
                                              Tween(begin: 0.1, end: 1.0);
                                          return FadeTransition(
                                            opacity: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      transactionData[index].name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    transactionData[index].amount > 9999999999
                                        ? NumberFormat.compactCurrency(
                                                locale: 'id', symbol: 'Rp.')
                                            .format(
                                                transactionData[index].amount)
                                        : NumberFormat.currency(
                                                locale: 'id', symbol: 'Rp.')
                                            .format(
                                                transactionData[index].amount),
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: primary,
                                          size: 20,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: primary,
                                          size: 25,
                                        ),
                                        onPressed: () => _delete(
                                            transactionData[index].id ?? 0),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(currentTab: 2),
    );
  }
}

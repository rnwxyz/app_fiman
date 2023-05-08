import 'package:app_fiman/blocs/create/create_bloc.dart';
import 'package:app_fiman/blocs/history/history_bloc.dart';
import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/utils/componen/text_field.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final namaTransaksiController = TextEditingController();
  final jumlahController = TextEditingController();
  final kategoriController = TextEditingController();
  final tanggalController = TextEditingController();
  final keteranganController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime CurrentDate = DateTime.now();
  final Validator validator = Validator();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namaTransaksiController.dispose();
    jumlahController.dispose();
    kategoriController.dispose();
    tanggalController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<CreateBloc>().add(CreateInitialEvent());
    super.initState();
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: CurrentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date == null) return;
    selectedDate = date;
    tanggalController.text =
        DateFormat('EEEE, d MMMM yyyy', "id_ID").format(date);
  }

  void _formSubmit() {
    if (_formKey.currentState!.validate()) {
      if (kategoriController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih kategori dulu bre !'),
          ),
        );
      } else {
        final data = TransactionModel(
          name: namaTransaksiController.text,
          amount: int.parse(jumlahController.text),
          category: int.parse(kategoriController.text),
          date: DateTime.parse(DateFormat("yyyy-MM-dd").format(selectedDate)),
          description: keteranganController.text,
        );
        context.read<CreateBloc>().add(CreateSubmitEvent(data));
        namaTransaksiController.clear();
        jumlahController.clear();
        kategoriController.clear();
        tanggalController.clear();
        keteranganController.clear();
        context
            .read<HistoryBloc>()
            .add(HistoryFetchEvent(loadMore: false, search: ""));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi"),
        centerTitle: true,
        backgroundColor: primary,
        elevation: 0,
      ),
      body: Container(
        color: primary,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            minimum: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lengkapin ya bre !',
                      style: headline2,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<CreateBloc, CreateState>(
                          builder: (context, state) {
                            if (state is CategoryPemasukanSelected) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(success),
                                  foregroundColor:
                                      MaterialStateProperty.all(white),
                                  // add border color
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: success, width: 1),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<CreateBloc>()
                                      .add(CreateInitialEvent());
                                  kategoriController.text = '';
                                },
                                child: const Text(
                                  'Pemasukan',
                                  style: button,
                                ),
                              );
                            } else {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(white),
                                  foregroundColor:
                                      MaterialStateProperty.all(black),
                                  // add border color
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: accent, width: 1),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<CreateBloc>().add(
                                      CreateCategoryPemasukanSelectedEvent());
                                  kategoriController.text = "$pemasukanId";
                                },
                                child: const Text(
                                  'Pemasukan',
                                  style: button2,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        BlocBuilder<CreateBloc, CreateState>(
                          builder: (context, state) {
                            if (state is CategoryPengeluaranSelected) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(danger),
                                  foregroundColor:
                                      MaterialStateProperty.all(white),
                                  // add border color
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: danger, width: 1),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<CreateBloc>()
                                      .add(CreateInitialEvent());
                                  kategoriController.text = '';
                                },
                                child: const Text(
                                  'Pengeluaran',
                                  style: button,
                                ),
                              );
                            } else {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(white),
                                  foregroundColor:
                                      MaterialStateProperty.all(black),
                                  // add border color
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: accent, width: 1),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<CreateBloc>().add(
                                      CreateCategoryPengeluaranSelectedEvent());
                                  kategoriController.text = "$pengeluaranId";
                                },
                                child: const Text(
                                  'Pengeluaran',
                                  style: button2,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: namaTransaksiController,
                        label: "Nama Transaksi",
                        vlidator: validator.nameValidator,
                        keyboardType: TextInputType.text,
                        onTap: () {},
                        isReadOnly: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: jumlahController,
                        label: "Jumlah",
                        vlidator: validator.jumlahValidator,
                        keyboardType: TextInputType.number,
                        onTap: () {},
                        isReadOnly: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: tanggalController,
                        label: "Tanggal",
                        vlidator: validator.tanggalValidator,
                        keyboardType: TextInputType.text,
                        onTap: _showDatePicker,
                        isReadOnly: true),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: keteranganController,
                      label: "Keterangan",
                      vlidator: (p) {},
                      keyboardType: TextInputType.text,
                      onTap: () {},
                      isReadOnly: false,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primary),
                        foregroundColor: MaterialStateProperty.all(white),
                        // add border color
                        side: MaterialStateProperty.all(
                          BorderSide(width: 1, color: primary),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: _formSubmit,
                      child: BlocConsumer<CreateBloc, CreateState>(
                        listener: (context, state) {
                          if (state is CreateError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menambahkan transaksi'),
                              ),
                            );
                          } else if (state is CreateSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil menambahkan transaksi'),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is CreateLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Text(
                              'Tambah',
                              style: button,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

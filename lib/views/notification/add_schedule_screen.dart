import 'package:app_fiman/blocs/schedule/schedule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/create/create_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../models/schedule_model.dart';
import '../../utils/componen/text_field.dart';
import '../../utils/constants/contant.dart';
import '../../utils/validator/validator.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final namaTransaksiController = TextEditingController();
  final jumlahController = TextEditingController();
  final kategoriController = TextEditingController();
  final tanggalController = TextEditingController();
  final keteranganController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final Validator validator = Validator();
  final _formKey = GlobalKey<FormState>();
  int? day;
  int? month;
  int? year;

  @override
  void initState() {
    context.read<CreateBloc>().add(CreateInitialEvent());
    super.initState();
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
        final data = ScheduleModel(
          name: namaTransaksiController.text,
          amount: int.parse(jumlahController.text),
          category: int.parse(kategoriController.text),
          description: keteranganController.text,
          day: day,
          month: month,
          year: year,
          isNotifed: false,
        );
        context.read<CreateBloc>().add(CreateSchedule(data));
        namaTransaksiController.clear();
        jumlahController.clear();
        kategoriController.clear();
        tanggalController.clear();
        keteranganController.clear();
        context.read<ScheduleBloc>().add(ScheduleFeatch());
        context.read<NotificationBloc>().add(NotificationFeatch());
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jadwal", style: headline2),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: black,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
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
                                    const BorderSide(color: success, width: 1),
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
                                    const BorderSide(color: accent, width: 1),
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
                                    const BorderSide(color: danger, width: 1),
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
                                    const BorderSide(color: accent, width: 1),
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
                      controller: keteranganController,
                      label: "Keterangan",
                      vlidator: (p) {},
                      keyboardType: TextInputType.text,
                      onTap: () {},
                      isReadOnly: false,
                    ),
                    const SizedBox(height: 20),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Atur Jadwal Tiap...', style: headline3)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                day = int.parse(value);
                              } else {
                                day = null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Tanggal',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                month = int.parse(value);
                              } else {
                                month = null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Bulan',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                year = int.parse(value);
                              } else {
                                year = null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Tahun',
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primary),
                        foregroundColor: MaterialStateProperty.all(white),
                        // add border color
                        side: MaterialStateProperty.all(
                          const BorderSide(width: 1, color: primary),
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
                                content: Text('Gagal menambahkan jadwal'),
                              ),
                            );
                          } else if (state is CreateSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil menambahkan jadwal'),
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
                              'JADWALKAN',
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

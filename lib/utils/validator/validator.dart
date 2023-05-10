class Validator {
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }
    return null;
  }

  String? jumlahValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon harus diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Harus angka';
    }
    return null;
  }

  String? tanggalValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal harus diisi';
    }
    return null;
  }
}

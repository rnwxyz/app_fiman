class Validator {
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }
    final nameKapitalRegex = RegExp(r'^[A-Z]\S*(?:\s+[A-Z]\S*)*$');
    if (!nameKapitalRegex.hasMatch(value)) {
      return 'Tiap kata dimulai kapital';
    }
    final minimumWorldRegex = RegExp(r'^\S+\s+\S+.*$');
    if (!minimumWorldRegex.hasMatch(value)) {
      return 'Minimal dua kata';
    }
    final specialCharRegex = RegExp(r'[!@#%^$&*(),.?":{}|<>1234567890]');
    if (specialCharRegex.hasMatch(value)) {
      return 'Hanya boleh menggunakan huruf';
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

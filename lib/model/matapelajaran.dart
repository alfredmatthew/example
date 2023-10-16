class Matapelajaran {
  final int? id;
  final String? name;
  final String? guru;
  final String? deskripsi;

  Matapelajaran({
    this.id,
    this.name,
    this.guru,
    this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'guru': guru,
      'deskripsi': deskripsi,
    };
  }

  @override
  String toString() {
    return 'Matapelajaran{id: $id, name: $name, guru: $guru, deskripsi: $deskripsi}';
  }
}

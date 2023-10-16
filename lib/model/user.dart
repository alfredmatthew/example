class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? telepon;
  final String? token;
  final String? tanggalLahir;
  final String? usia;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.telepon,
      this.token,
      this.tanggalLahir,
      this.usia});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'telepon': telepon,
      'tanggalLahir': tanggalLahir,
      'token': token,
      // Add other properties as needed
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, telepon: $telepon, tanggallahir: $tanggalLahir, usia: $usia, token: $token}';
  }
}

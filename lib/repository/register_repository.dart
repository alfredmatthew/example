import 'package:example/model/user.dart';
import 'package:example/database/sql_helper.dart';

//variabel global
List<Map<String,dynamic>> users = [];

class RegisterRepository {

  String generateToken() {
    return "generated_token";
  }
  
  void clearUsers() {
    users.clear();
  }

  void printAllUsers() {
    for (Map<String, dynamic> userData in users) {
      print(users.toString());
    }
  }

  Future<void> addEmployee(String name, String email, String password, String telepon, String token, String tanggalLahir, String usia) async {
    await SQLHelper.addUser(name, email, password, telepon, token, tanggalLahir, usia);
  }

  // register dengan data yang dinamis
  Future<void> register(String name, String email, String password, String telepon, String tanggalLahir, String usia) async {
    print("Registering...");

    await Future.delayed(Duration(seconds: 3), () {
      if (users.any((user) => user['email'] == email)) {
        throw 'Email telah dipakai user lain';
      } else if (name.isEmpty || password.isEmpty || email.isEmpty || telepon.isEmpty) {
        throw 'Field harus diisi semua';
      } else {
        addEmployee(name, email, password, telepon, generateToken(), tanggalLahir, usia);
      }
      return users;
    });
  }

}

// class registerRepository {
//   //global variable
//   List<User> users = [];

//   void registerUser(String username, String password) {
//     if (users.any((user) => user.name == username)) {
//       throw 'Username is already taken';
//     }
//     users.add(User(name: username, password: password, token: generateToken()));
//   }

//   String generateToken() {
//     return "generated_token";
//   }

//   // register with dynamically checked user data
//   Future<User> register(String username, String password) async {
//     print("Registrating...");

//     await Future.delayed(Duration(seconds: 3), () {
//       for (User user in users) {
//         if (user.name == username && user.password == password) {
//           return user; // Return the matched user
//         }
//       }
//       if (username == '' || password == '') {
//         throw 'Username or password cannot be empty';
//       } else {
//         throw FailedRegister();
//       }
//     });
//     return userData;
//   }
// }

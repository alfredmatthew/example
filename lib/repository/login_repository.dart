import 'package:example/model/user.dart';
import 'package:example/repository/register_repository.dart';

class FailedLogin implements Exception {
  String errorMessage() {
    return "Login Failed";
  }
}

class LoginRepository {
  Future<User> login(String username, String password) async {
    print("Login in...");
    User userData = User();
    await Future.delayed(Duration(seconds: 3), () {
      for (Map<String, dynamic> userDetail in users) {
        if (userDetail['name'] == username && userDetail['password'] == password) {
            userData = User(
            id: userDetail['id'],
            name: userDetail['name'],
            email: userDetail['email'],
            password: userDetail['password'],
            telepon: userDetail['telepon'],
            tanggalLahir: userDetail['tanggalLahir'],
            token: userDetail['token'],
            usia: userDetail['usia'],
          );

          return userData;
        }
      }
      throw FailedLogin();
    });
    return userData;
  }
}

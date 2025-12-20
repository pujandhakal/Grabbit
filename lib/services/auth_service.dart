import 'package:grabbit/models/user.dart';
import "package:http/http.dart" as http;

class AuthService {
  //sign up user
  void signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        password: password,
        email: email,
        phone: "",
        type: "",
        token: "",
      );

      http.Response res = await http.post(
          Uri.parse("http://192.168.18.96:3000/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": 'application/json; charset = UTF-8',
          });
    } catch (e) {}
  }
}

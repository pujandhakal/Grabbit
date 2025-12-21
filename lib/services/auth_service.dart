import 'package:flutter/material.dart';
import 'package:grabbit/constants/error_handling.dart';
import 'package:grabbit/constants/utils.dart';
import 'package:grabbit/models/user.dart';
import "package:http/http.dart" as http;

class AuthService {
  //sign up user
  void signUpUser({
    required BuildContext context,
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
          Uri.parse("http://192.168.1.69:3000/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context, "Account Created! Login with the same credentials");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

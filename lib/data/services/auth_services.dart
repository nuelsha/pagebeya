import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pagebeya/data/provider/user_provider.dart';
import 'dart:convert';

import 'package:pagebeya/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  void signUp(
      {required BuildContext context,
      required String name,
      required String phone,
      required String email,
      required String password}) async {
    try {
      User user = User(id: "", name: name, email: email, phone: phone);
      http.Response res = await http.post(
        Uri.parse(
            'https://pa-ecommerce-g3fa44gsl-biniyam-29s-projects.vercel.app/auth'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        // Handle success
      } else {
        // Handle error
      }
      httphandleError(
        res: res,
        context: context,
        onSuccess: () {
          // Handle success
          showSnackBar(context,
              'Registration successful please login with your credentials');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void login({
    required BuildContext context,
    required String phone,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
          Uri.parse(
              "https://pa-ecommerce-g3fa44gsl-biniyam-29s-projects.vercel.app/auth/login"),
          body: jsonEncode({"phoneNum": phone, "password": password}),
          headers: <String, String>{'Content-Type': 'application/json'});

      httphandleError(
        res: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          showSnackBar(context, 'Login successful');
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');
    Provider.of<UserProvider>(context, listen: false)..setUser('{}');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    showSnackBar(context, 'Logged out successfully');
  }

  // void getUserData({required BuildContext context}) async {
  //   try {
  //     var userProvider = Provider.of<UserProvider>(context, listen: false);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('x-auth-token');
  //     if (token == null){
  //       prefs.setString('x-auth-token', '');

  //     }
  //     var tokenRes= await http.post(
  //         Uri.parse(
  //             "https://pa-ecommerce-g3fa44gsl-biniyam-29s-projects.vercel.app/auth/token"),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'x-auth-token': token!});

  //           var response = jsonDecode(tokenRes.body);

  //           if (response['message'] == 'Token is valid') {
  //             var userRes = await http.get(
  //                 Uri.parse(
  //                     "https://pa-ecommerce-g3fa44gsl-biniyam-29s-projects.vercel.app/auth/user"),
  //                 headers: <String, String>{
  //                   'Content-Type': 'application/json',
  //                   'x-auth-token': token
  //                 });

  //             userProvider.setUser(userRes.body);
  //           } else {
  //             prefs.setString('x-auth-token', '');
  //             showSnackBar(context, 'Session expired please login again');
  //             Navigator.pushReplacementNamed(context, '/login');
  //           }

  // } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }
}

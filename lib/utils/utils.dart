import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void httphandleError({
  required http.Response res,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (res.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(res.body)['message']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(res.body)['error']);
      break;
    default:
      showSnackBar(context, res.body);
  }
}

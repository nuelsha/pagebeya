import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;

  static String handleError(dynamic error) {
    if (error is NetworkException) {
      return error.message;
    } else if (error is SocketException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Connection timeout';
    } else if (error is http.ClientException) {
      return 'Server connection failed';
    } else if (error is FormatException) {
      return 'Invalid server response';
    } else {
      return 'Unexpected error occurred';
    }
  }
}

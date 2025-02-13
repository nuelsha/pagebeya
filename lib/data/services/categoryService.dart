import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagebeya/data/models/Category.dart';

class CategoryService {
  static const String _baseUrl = 'https://1clr2kph-3005.uks1.devtunnels.ms';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

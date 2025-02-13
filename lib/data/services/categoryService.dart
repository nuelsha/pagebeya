import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagebeya/data/models/Category.dart';

class CategoryService {
  static const String _baseUrl =
      'https://pa-ecommerce-g3fa44gsl-biniyam-29s-projects.vercel.app';

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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagebeya/data/models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://1clr2kph-3005.uks1.devtunnels.ms';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/product'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProduct(String productId) async {
    final response = await http.get(Uri.parse('$_baseUrl/product/$productId'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}

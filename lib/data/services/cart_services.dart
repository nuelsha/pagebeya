import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pagebeya/data/models/cartitem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String _baseUrl = 'https://1clr2kph-3005.uks1.devtunnels.ms';

  Future<List<CartItem>> fetchCart(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    final response = await http.get(
      Uri.parse('$_baseUrl/carts?userId=$userId'),
      headers: {'x-auth-token': token ?? ''},
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => CartItem.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<CartItem> addToCart(
      String userId, String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    final response = await http.post(
      Uri.parse('$_baseUrl/carts'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token ?? '',
      },
      body: jsonEncode(
          {'userId': userId, 'productId': productId, 'quantity': quantity}),
    );
    if (response.statusCode == 200) {
      return CartItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  Future<void> removeCartItem(String cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/carts/$cartId'),
      headers: {'x-auth-token': token ?? ''},
    );
    if (response.statusCode != 200)
      throw Exception('Failed to delete cart item');
  }
}

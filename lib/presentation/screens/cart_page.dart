import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/cartitem.dart';
import 'package:pagebeya/data/models/product.dart';
import 'package:pagebeya/data/provider/cart_provider.dart';
import 'package:pagebeya/data/provider/prodact_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void updateQuantity(String cartId, int delta) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // You might implement something like:
    // await cartProvider.updateQuantity(cartId, newQuantity);
    // For now, we’re simply adjusting the local model (not recommended for production):
    final index = cartProvider.items.indexWhere((item) => item.id == cartId);
    if (index != -1) {
      final currentItem = cartProvider.items[index];
      // Calculate new quantity and clamp between 1 and 99.
      final newQuantity = (currentItem.quantity + delta).clamp(1, 99) as int;
      // Ideally, call an API method here to update the cart item.
      setState(() {
        cartProvider.items[index] = CartItem(
          id: currentItem.id,
          userId: currentItem.userId,
          productId: currentItem.productId,
          quantity: newQuantity,
        );
      });
    }
  }

  // Remove a cart item by calling the API through CartProvider.
  void removeItem(String cartId) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    try {
      // Assumes you’ve added a removeItem method in your CartProvider that calls
      // CartService.removeCartItem and updates _items accordingly.
      await cartProvider.removeItem(cartId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  // Computes the subtotal by matching each cart item with its product details.
  double computeSubtotal(List<CartItem> cartItems, List<Product> products) {
    double subtotal = 0.0;
    for (var cartItem in cartItems) {
      final product = products.firstWhere(
        (p) => p.id == cartItem.productId,
        orElse: () => Product(
          id: '',
          name: 'Unknown',
          price: '0',
          description: '',
          detail: '',
          quantity: 0,
          brandId: '',
          image: '',
        ),
      );
      subtotal += (double.tryParse(product.price) ?? 0.0) * cartItem.quantity;
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItems = cartProvider.items;
    final products = productProvider.products;

    final subtotal = computeSubtotal(cartItems, products);
    final shipping = 0.0;
    final tax = 0.0;
    final total = subtotal + shipping + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart (${cartItems.length})'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      // Look up product details from ProductProvider.
                      final product = products.firstWhere(
                        (p) => p.id == cartItem.productId,
                        orElse: () => Product(
                          id: '',
                          name: 'Unknown',
                          price: '0',
                          description: '',
                          detail: '',
                          quantity: 0,
                          brandId: '',
                          image: '',
                        ),
                      );
                      return Dismissible(
                        key: Key(cartItem.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          removeItem(cartItem.id);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: _buildCartItem(product, cartItem),
                      );
                    },
                  ),
                ),
                _buildSummary(subtotal, shipping, tax, total),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Add items to your cart to start shopping',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Start Shopping'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product, CartItem cartItem) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Birr ${double.tryParse(product.price)?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      color: const Color.fromRGBO(230, 0, 0, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => updateQuantity(cartItem.id, -1),
                      ),
                      Text('${cartItem.quantity}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => updateQuantity(cartItem.id, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(
      double subtotal, double shipping, double tax, double total) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', subtotal),
            SizedBox(height: 4),
            _buildSummaryRow('Shipping', shipping),
            SizedBox(height: 4),
            _buildSummaryRow('Tax', tax),
            Divider(height: 24),
            _buildSummaryRow('Total', total, isTotal: true),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Checkout', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/checkout');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
        Text(
          'Birr ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
            color: isTotal ? const Color.fromRGBO(230, 0, 0, 1) : null,
          ),
        ),
      ],
    );
  }
}

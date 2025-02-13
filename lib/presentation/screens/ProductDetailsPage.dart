import 'package:flutter/material.dart';
import 'package:pagebeya/data/provider/cart_provider.dart';
import 'package:pagebeya/data/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pagebeya/data/models/product.dart';


class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({required this.product, Key? key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void updateQuantity(int delta) {
    setState(() {
      quantity = (quantity + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: widget.product.image.isNotEmpty
                  ? Image.network(
                      widget.product.image,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "https://pagebeya.netlify.app/static/media/PA-Logos.8da782d0218b411fb3e0.png",
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  // Price (parsed from string to double)
                  Builder(builder: (context) {
                    final parsedPrice =
                        double.tryParse(widget.product.price) ?? 0;
                    return Text(
                      '$parsedPrice Birr',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color.fromRGBO(230, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                          ),
                    );
                  }),
                  SizedBox(height: 16),
                  // Quantity Controls
                  Row(
                    children: [
                      Text('Quantity:',
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => updateQuantity(-1),
                        color: const Color.fromRGBO(230, 0, 0, 1),
                      ),
                      Text(
                        '$quantity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => updateQuantity(1),
                        color: const Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // Using CartProvider's addItem method to add the product to the cart
                        cartProvider.addItem(
                          userProvider.user?.id ?? '',
                          widget.product.id,
                          quantity,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart')),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  // Product Details
                  Text(
                    'Product Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Product Features (static/dummy features can be updated as needed)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeatureItem(context, 'Feature 1'),
                      _buildFeatureItem(context, 'Feature 2'),
                      _buildFeatureItem(context, 'Feature 3'),
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

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: const Color.fromRGBO(230, 0, 0, 1),
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(feature, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/Category.dart';
import 'package:pagebeya/data/services/auth_services.dart';
import 'package:pagebeya/data/provider/cart_provider.dart';
import 'package:pagebeya/data/provider/catagori_provider.dart';
import 'package:pagebeya/data/provider/prodact_provider.dart';
import 'package:pagebeya/data/provider/user_provider.dart';
import 'package:pagebeya/presentation/screens/ProductDetailsPage.dart';
import 'package:provider/provider.dart';
import 'package:pagebeya/data/models/product.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 0, 0, 1),
        iconTheme: IconThemeData(color: Colors.white),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'What are you looking for?',
            hintStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.black),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(230, 0, 0, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PAGEBYA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color.fromRGBO(230, 0, 0, 1)),
              title: Text('User Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart,
                  color: Color.fromRGBO(230, 0, 0, 1)),
              title: Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.feedback, color: Color.fromRGBO(230, 0, 0, 1)),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/feedback');
              },
            ),
            Divider(color: Colors.red[100]),
            ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: Color.fromRGBO(230, 0, 0, 1)),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                final AuthServices authServices = AuthServices();
                authServices.logout(context);
                // Implement logout logic here
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                PromoBanner(),
                CategoryGrid(),
                ProductList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Text("Contact Number"),
                content: const Text(
                  "+251 911 111 111",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  void initState() {
    super.initState();
    // Load categories on widget initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  Future<void> _refreshCategories() async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        // Show loading indicator if categories are loading.
        if (categoryProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        // Display error if one occurred.
        if (categoryProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${categoryProvider.error}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _refreshCategories,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        final List<Category> categories = categoryProvider.categories;
        if (categories.isEmpty) {
          return Center(child: Text('No categories available'));
        }
        // Wrap the grid in a RefreshIndicator for pull-to-refresh functionality.
        return RefreshIndicator(
          onRefresh: _refreshCategories,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryItem(
                        context,
                        category.name,
                        category.image,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String categoryName, String? imageUrl) {
    // Check for an empty imageUrl as well as null.
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return InkWell(
      onTap: () {
        // Handle category tap (e.g., filter products by category)
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Display a network image if available; otherwise, use a gradient.
              image: hasImage
                  ? DecorationImage(
                      image: NetworkImage(imageUrl ?? 'assets/images/logo.png'),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: !hasImage
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(230, 0, 0, 0.7),
                        Color.fromRGBO(255, 52, 52, 1)
                      ],
                    )
                  : null,
            ),
            child: !hasImage
                ? Icon(Icons.category, color: Colors.white, size: 30)
                : null,
          ),
          SizedBox(height: 8),
          Text(
            categoryName,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
    // Trigger loading products from the API via the ProductProvider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (productProvider.error != null) {
          return Center(child: Text('Error: ${productProvider.error}'));
        }
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth > 600) crossAxisCount = 3;
                  if (constraints.maxWidth > 900) crossAxisCount = 4;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ProductGridItem(product: product);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductGridItem extends StatefulWidget {
  final Product product;

  const ProductGridItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  int quantity = 1;

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Added to Cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.product.name} (Qty: $quantity)',
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: widget.product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${widget.product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Builder(builder: (context) {
                    final parsedPrice =
                        double.tryParse(widget.product.price) ?? 0;
                    return Text(
                      '\$${parsedPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.w600),
                    );
                  }),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildQuantityButton(Icons.remove, () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              }),
                              Expanded(
                                child: Text(
                                  '$quantity',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              _buildQuantityButton(Icons.add, () {
                                setState(() {
                                  quantity++;
                                });
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      _buildAddToCartButton(cartProvider, userProvider),
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

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildAddToCartButton(
      CartProvider cartProvider, UserProvider userProvider) {
    return InkWell(
      onTap: () {
        if (userProvider.user != null) {
          cartProvider.addItem(
              userProvider.user!.id, widget.product.id, quantity);
          _showSnackBar(context);
        } else {
          // Handle the case when user is null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not logged in'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _showSnackBar(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(230, 0, 0, 1),
        ),
        child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
      ),
    );
  }
}

class PromoBanner extends StatefulWidget {
  @override
  _PromoBannerState createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final List<String> images = [
    'assets/images/promo1.png',
    'assets/images/promo2.png',
    'assets/images/promo3.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        },
      ),
    );
  }
}

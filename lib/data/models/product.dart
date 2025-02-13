class Product {
  final String id;
  final String name;
  final String price;
  final String description;
  final String detail;
  final int quantity;
  final String brandId;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.detail,
    required this.quantity,
    required this.brandId,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        price: json['price'] ?? '',
        description: json['description'] ?? '',
        detail: json['detail'] ?? '',
        quantity: json['quantity'] ?? 0,
        brandId: json['brandId'] ?? '',
        image: json['image'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'description': description,
        'detail': detail,
        'quantity': quantity,
        'brandId': brandId,
        'image': image,
      };
}

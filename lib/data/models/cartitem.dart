class CartItem {
  final String id;
  final String userId;
  final String productId;
  final int quantity;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        productId: json['productId'] ?? '',
        quantity: json['quantity'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'productId': productId,
        'quantity': quantity,
      };
}

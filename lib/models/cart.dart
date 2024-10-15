class CartItem {
  final int id;
  final int productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({required this.id, required this.productId, required this.name, required this.price, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

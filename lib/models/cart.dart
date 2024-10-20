class CartItem {
  final int id;
  final int productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({required this.id, required this.productId, required this.name, required this.price, required this.quantity, required this.imageUrl});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      quantity: json['quantity'],
      imageUrl: json['image_url']
    );
  }
}

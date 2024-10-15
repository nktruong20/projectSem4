class Product {
  final int id;
  final String name;
  final int? categoryId;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:json["id"],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
      stock: json['stock'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    };
  }
}

class Category {
  final int? id; // id có thể là null
  final String name; // name không thể là null
  final String description; // description không thể là null

  // Constructor với id là nullable
  Category({
    this.id, // Không cần 'required' cho id vì có thể null
    required this.name,
    required this.description,
  });

  // Phương thức để tạo một Category từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    // Đảm bảo name và description không phải là null
    if (json['name'] == null || json['description'] == null) {
      throw Exception('Name and description must not be null');
    }

    return Category(
      id: json['id'] != null ? json['id'] as int : null, // Chuyển đổi id
      name: json['name'] as String, // Chuyển đổi name
      description: json['description'] as String, // Chuyển đổi description
    );
  }

  // Phương thức để chuyển đổi Category thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // id có thể là null
      'name': name,
      'description': description,
    };
  }
}

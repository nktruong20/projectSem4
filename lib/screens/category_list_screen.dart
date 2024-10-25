import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import 'add_category_screen.dart';
import '../services/auth_service.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryController categoryController = CategoryController();
  final AuthService authService = AuthService();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Tải danh sách danh mục khi màn hình được khởi tạo
    _loadToken(); // Tải token khi màn hình được khởi tạo
  }

  Future<void> _loadToken() async {
    token = await authService.getToken(); // Lấy token từ AuthService
  }

  Future<void> _loadCategories() async {
    await categoryController.loadCategories(); // Tải danh sách danh mục từ database
    setState(() {}); // Cập nhật lại state để hiển thị danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Danh Mục'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: categoryController.loadCategories(), // Tải danh sách danh mục
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0), // Thêm padding cho danh sách
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Khoảng cách giữa các thẻ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(category.description),
                  ),
                  leading: const Icon(
                    Icons.category,
                    color: Colors.pinkAccent,
                    size: 40,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.pinkAccent,
                    onPressed: () {
                      if (category.id != null) { // Kiểm tra id có khác null không
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: Text('Bạn có chắc chắn muốn xóa danh mục "${category.name}" không?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Xóa category
                                    if (token != null) {
                                      try {
                                        await categoryController.deleteCategory(category.id!, token!); // Gọi hàm xóa với token
                                        Navigator.of(context).pop(); // Đóng dialog sau khi xóa thành công
                                        _loadCategories(); // Tải lại danh sách sau khi xóa
                                      } catch (e) {
                                        // Xử lý lỗi
                                        print('Error deleting category: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Lỗi khi xóa danh mục.')),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Không thể lấy token.')),
                                      );
                                    }
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print('ID danh mục không hợp lệ'); // Thông báo lỗi nếu ID là null
                      }
                    },
                  ),
                  onTap: () {
                    // Logic for tapping on the category
                    print('Selected category: ${category.name}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Điều hướng đến trang thêm danh mục
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryScreen(),
            ),
          );

          // Nếu giá trị trả về là true, tải lại danh sách danh mục
          if (result == true) {
            _loadCategories(); // Gọi hàm tải lại danh sách
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent, // Màu cho nút thêm
      ),
    );
  }
}

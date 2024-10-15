import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';
import '../services/auth_service.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  bool _isLoading = false;

  final CategoryController categoryController = CategoryController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Danh Mục Mới'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên danh mục',
                    labelStyle: const TextStyle(color: Colors.pinkAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                    ),
                  ),
                  onSaved: (value) {
                    _name = value?.trim(); // Remove any extra spaces
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên danh mục';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Khoảng cách giữa các trường
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả danh mục',
                    labelStyle: const TextStyle(color: Colors.pinkAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                    ),
                  ),
                  onSaved: (value) {
                    _description = value?.trim(); // Remove any extra spaces
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả danh mục';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      _formKey.currentState?.save();

                      Category newCategory = Category(
                        name: _name!,
                        description: _description!,
                      );

                      try {
                        String? token = await authService.getToken();
                        if (token == null) {
                          print('Token is null');
                          return;
                        }
                        setState(() {
                          _isLoading = true; // Show loading indicator
                        });
                        await categoryController.addCategory(newCategory, token);
                        print('Thêm danh mục thành công!');
                        Navigator.pop(context, true);
                      } catch (e) {
                        print('Lỗi khi thêm danh mục: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent, // Màu nền nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Lưu danh mục',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

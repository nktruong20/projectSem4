import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  double? _price;
  String? _imageUrl;
  int? _selectedCategoryId;

  final CategoryController categoryController = CategoryController();
  final ProductService productService = ProductService();
  final AuthService authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    await categoryController.loadCategories();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm Mới'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Logic for updating product
              print('Update product'); // Replace with actual update logic
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Logic for deleting product
              print('Delete product'); // Replace with actual delete logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Vui lòng nhập thông tin sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Tên sản phẩm',
                          icon: Icons.shopping_cart,
                          onSaved: (value) => _name = value?.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tên sản phẩm';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16), // Khoảng cách giữa các trường
                        _buildTextField(
                          label: 'Mô tả sản phẩm',
                          icon: Icons.description,
                          onSaved: (value) => _description = value?.trim(),
                        ),
                        const SizedBox(height: 16), // Khoảng cách giữa các trường
                        _buildTextField(
                          label: 'Giá sản phẩm',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _price = double.tryParse(value?.trim() ?? '');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập giá sản phẩm';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16), // Khoảng cách giữa các trường
                        _buildTextField(
                          label: 'URL hình ảnh',
                          icon: Icons.image,
                          onSaved: (value) => _imageUrl = value?.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập URL hình ảnh';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Danh mục',
                            icon: Icon(Icons.category),
                          ),
                          items: categoryController.categories
                              .map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn danh mục';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true) {
                              _formKey.currentState?.save();

                              if (_selectedCategoryId == null ||
                                  _name == null ||
                                  _price == null ||
                                  _imageUrl == null) {
                                print('Một hoặc nhiều giá trị là null');
                                return;
                              }

                              Product newProduct = Product(
                                id: _selectedCategoryId!,
                                categoryId: _selectedCategoryId!,
                                name: _name!,
                                description: _description ?? '',
                                price: _price!,
                                stock: 0, // Hoặc loại bỏ nếu không cần
                                imageUrl: _imageUrl!,
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
                                await productService.addProduct(newProduct, token);
                                print('Thêm sản phẩm thành công!');
                                Navigator.pop(context); // Quay lại màn hình trước
                              } catch (e) {
                                print('Lỗi khi thêm sản phẩm: $e');
                              } finally {
                                setState(() {
                                  _isLoading = false; // Hide loading indicator
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                          ),
                          child: const Text(
                            'Lưu sản phẩm',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}

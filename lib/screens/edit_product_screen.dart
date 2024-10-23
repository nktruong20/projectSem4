import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product; // Nhận sản phẩm hiện tại

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  double? _price;
  int? _stock;
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
    // Khởi tạo giá trị từ sản phẩm hiện tại
    _name = widget.product.name;
    _description = widget.product.description;
    _price = widget.product.price;
    _stock = widget.product.stock;
    _imageUrl = widget.product.imageUrl;
    _selectedCategoryId = widget.product.categoryId; // Gán danh mục hiện tại
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
        title: const Text('Chỉnh Sửa Sản Phẩm'),
        backgroundColor: Colors.pinkAccent, // Màu hồng cho AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Trường tên sản phẩm
                _buildTextField(
                  label: 'Tên sản phẩm',
                  initialValue: _name,
                  onSaved: (value) => _name = value?.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập tên sản phẩm'
                      : null,
                ),
                const SizedBox(height: 16),

                // Trường mô tả sản phẩm
                _buildTextField(
                  label: 'Mô tả sản phẩm',
                  initialValue: _description,
                  onSaved: (value) => _description = value?.trim(),
                ),
                const SizedBox(height: 16),

                // Trường giá sản phẩm
                _buildTextField(
                  label: 'Giá sản phẩm',
                  initialValue: _price?.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _price = double.tryParse(value?.trim() ?? ''),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập giá sản phẩm'
                      : null,
                ),
                const SizedBox(height: 16),

                // Trường số lượng sản phẩm
                _buildTextField(
                  label: 'Số lượng sản phẩm',
                  initialValue: _stock?.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _stock = int.tryParse(value?.trim() ?? ''),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập số lượng sản phẩm'
                      : null,
                ),
                const SizedBox(height: 16),

                // Trường URL hình ảnh
                _buildTextField(
                  label: 'URL hình ảnh',
                  initialValue: _imageUrl,
                  onSaved: (value) => _imageUrl = value?.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập URL hình ảnh'
                      : null,
                ),
                const SizedBox(height: 20),

                // Dropdown để chọn danh mục
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                  ),
                  items: categoryController.categories.map((category) {
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
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn danh mục' : null,
                ),
                const SizedBox(height: 20),

                // Nút lưu sản phẩm
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: const Text('Lưu sản phẩm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
    String? initialValue,
    TextInputType? keyboardType,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.pink),
        ),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      style: const TextStyle(color: Colors.black),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      if (_selectedCategoryId == null ||
          _name == null ||
          _price == null ||
          _stock == null ||
          _imageUrl == null) {
        print('Một hoặc nhiều giá trị là null');
        return;
      }

      Product updatedProduct = Product(
        id: widget.product.id, // Giữ ID cũ của sản phẩm
        categoryId: _selectedCategoryId!,
        name: _name!,
        description: _description ?? '',
        price: _price!,
        stock: _stock!,
        imageUrl: _imageUrl!,
      );

      try {
        String? token = await authService.getToken();
        if (token == null) {
          print('Token is null');
          return;
        }
        setState(() {
          _isLoading = true; // Hiển thị loading
        });
        await productService.updateProduct(widget.product.id, updatedProduct, token); // Gọi hàm update
        print('Cập nhật sản phẩm thành công!');
        Navigator.pop(context); // Quay lại màn hình trước
      } catch (e) {
        print('Lỗi khi cập nhật sản phẩm: $e');
      } finally {
        setState(() {
          _isLoading = false; // Ẩn loading
        });
      }
    }
  }
}

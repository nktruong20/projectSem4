import 'package:flutter/material.dart';
import 'package:project_sem4/controllers/category_controller.dart';
import 'package:project_sem4/screens/products_category.dart';
import '../controllers/product_controller.dart';
import '../widgets/home_product_card.dart'; // Sử dụng HomeProductCard
import '../services/auth_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final ProductController productController = ProductController();
  final CategoryController categoryController = CategoryController();
  final AuthService authService = AuthService();
  List<Product> filteredProducts = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  Future<void> _loadProducts() async {
    await productController.loadProducts();
    setState(() {
      filteredProducts = productController.products;
    });
  }

  Future<void> _loadCategories() async {
    await categoryController.loadCategories();
    setState(() {
      categories = categoryController.categories;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isNotEmpty) {
        filteredProducts = productController.products
            .where((product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      } else {
        filteredProducts = productController.products;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm sản phẩm',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tìm kiếm theo danh mục",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0), // Tạo khoảng cách giữa các button
                  child: ElevatedButton(
                    onPressed: () {
                      if (category.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductCategoryScreen(
                                  categoryId: int.parse('${category.id}'),
                                  categoryName: category.name)),
                        );
                      }
                    },
                    child: Text(category
                        .name), // Thay `category.name` bằng thuộc tính bạn muốn hiển thị
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Đặt border radius
                        ),
                        foregroundColor: Colors.white, // Màu nền button
                        backgroundColor: Colors.pinkAccent),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // TextField cho tìm kiếm
            Text(
              "Tìm kiếm theo tên",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              onChanged: (value) {
                _filterProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên sản phẩm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      8.0), // Bo góc với bán kính 30.0 pixel
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Bo góc khi có focus
                  borderSide:
                      BorderSide(color: Colors.pink), // Màu viền khi focus
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),

            // Hiển thị kết quả tìm kiếm
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: Text('Không tìm thấy sản phẩm nào.'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Số lượng sản phẩm trên một hàng
                        childAspectRatio:
                            0.65, // Tỷ lệ chiều rộng và chiều cao của sản phẩm để hình ảnh đầy đủ
                        crossAxisSpacing: 10.0, // Khoảng cách giữa các sản phẩm
                        mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return HomeProductCard(
                          product: product, // Sử dụng HomeProductCard
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

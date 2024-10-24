import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../widgets/home_product_card.dart'; // Sử dụng HomeProductCard
import '../services/auth_service.dart';
import '../models/product_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final ProductController productController = ProductController();
  final AuthService authService = AuthService();
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await productController.loadProducts();
    setState(() {
      filteredProducts = productController.products;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isNotEmpty) {
        filteredProducts = productController.products
            .where((product) => product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
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
        title: const Text('Tìm kiếm sản phẩm', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // TextField cho tìm kiếm
            TextField(
              onChanged: (value) {
                _filterProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên sản phẩm...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bo góc với bán kính 30.0 pixel
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bo góc khi có focus
                  borderSide: BorderSide(color: Colors.pink), // Màu viền khi focus
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số lượng sản phẩm trên một hàng
                  childAspectRatio: 0.65, // Tỷ lệ chiều rộng và chiều cao của sản phẩm để hình ảnh đầy đủ
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

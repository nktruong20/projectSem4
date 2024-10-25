import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';
import '../services/auth_service.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController productController = ProductController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Tải sản phẩm khi khởi tạo
  }

  Future<void> _loadProducts() async {
    await productController.loadProducts(); // Tải danh sách sản phẩm từ database
    setState(() {}); // Cập nhật lại state để hiển thị danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sản Phẩm'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: productController.loadProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }
            if (productController.products.isEmpty) {
              return const Center(child: Text('Không có sản phẩm nào.'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 3,
              ),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return ProductCard(
                  product: product,
                  productController: productController,
                  authService: authService,
                  onProductDeleted: _loadProducts,
                  onProductUpdated: _loadProducts,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Điều hướng đến trang thêm sản phẩm
          final shouldReload = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );

          // Tải lại danh sách sản phẩm nếu sản phẩm mới được thêm
          if (shouldReload == true) {
            await _loadProducts();
          }
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        tooltip: 'Thêm sản phẩm mới',
      ),
    );
  }
}

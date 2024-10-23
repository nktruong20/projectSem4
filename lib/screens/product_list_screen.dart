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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tải lại sản phẩm mỗi khi trang này được hiển thị
    _loadProducts();
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
        padding: const EdgeInsets.all(12.0), // Tạo khoảng cách cho toàn bộ màn hình
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
                crossAxisCount: 1, // Hiển thị 1 sản phẩm trên mỗi hàng
                crossAxisSpacing: 10, // Khoảng cách ngang giữa các sản phẩm
                mainAxisSpacing: 15, // Khoảng cách dọc giữa các sản phẩm
                childAspectRatio: 3, // Điều chỉnh tỉ lệ chiều cao trên chiều rộng để sản phẩm to và rõ hơn
              ),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return ProductCard(
                  product: product,
                  productController: productController,
                  authService: authService,
                  onProductDeleted: _loadProducts, // Truyền callback để tải lại danh sách
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Điều hướng đến trang thêm sản phẩm
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );

          // Sau khi quay lại, tải lại sản phẩm
          await _loadProducts();
        },
        backgroundColor: Colors.pinkAccent, // Màu của nút thêm
        child: const Icon(Icons.add),
        tooltip: 'Thêm sản phẩm mới',
      ),
    );
  }
}

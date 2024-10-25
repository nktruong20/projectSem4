import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../widgets/home_product_card.dart'; // Sử dụng HomeProductCard
import '../models/product_model.dart';

class ProductCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  ProductCategoryScreen({required this.categoryId, required this.categoryName});

  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final ProductController productController = ProductController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(widget.categoryId);
  }

  Future<void> _loadProducts(int categoryId) async {
    await productController.getProductsByCategoryId(categoryId);
    setState(() {
      products = productController.products;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục: ${widget.categoryName}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị kết quả tìm kiếm
            Expanded(
              child: products.isEmpty
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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

import 'package:flutter/material.dart';
import 'package:project_sem4/screens/edit_product_screen.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';
import '../services/auth_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ProductController productController;
  final AuthService authService;
  final VoidCallback onProductDeleted;
  final VoidCallback onProductUpdated; // Callback cho cập nhật sản phẩm

  const ProductCard({
    Key? key,
    required this.product,
    required this.productController,
    required this.authService,
    required this.onProductDeleted,
    required this.onProductUpdated, // Thêm tham số callback vào constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Điều hướng đến EditProductScreen
                final shouldReload = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(
                      product: product,
                    ),
                  ),
                );

                // Nếu EditProductScreen trả về true, gọi callback để cập nhật
                if (shouldReload == true) {
                  onProductUpdated(); // Gọi hàm callback cập nhật
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác Nhận'),
                    content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Không'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Có'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  String? token = await authService.getToken();
                  if (token != null) {
                    await productController.deleteProduct(product.id, token);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sản phẩm đã được xóa.')),
                    );
                    onProductDeleted();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không thể lấy token.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
        onTap: () {
          // Hành động khi người dùng nhấn vào sản phẩm
        },
      ),
    );
  }
}

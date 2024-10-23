import 'package:flutter/material.dart';
import '../models/product_model.dart';

class HomeProductCard extends StatelessWidget {
  final Product product;

  const HomeProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến màn hình chi tiết sản phẩm khi nhấn vào card
        Navigator.pushNamed(
          context,
          '/productDetail',
          arguments: product, // Truyền product đến màn hình chi tiết
        );
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bo tròn góc của card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Đảm bảo không tràn
          children: [
            // Hình ảnh sản phẩm
            Container(
              height: 180, // Chiều cao hình ảnh
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), // Bo tròn góc
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover, // Đảm bảo hình ảnh chiếm toàn bộ không gian
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Giá sản phẩm
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

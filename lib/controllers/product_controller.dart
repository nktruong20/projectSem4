import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController {
  final ProductService productService = ProductService();
  List<Product> products = [];

  // 1. Đọc - Lấy danh sách sản phẩm từ backend
  Future<void> loadProducts() async {
    try {
      products = await productService.getProducts();
    } catch (e) {
      print('Lỗi khi tải danh sách sản phẩm: $e');
    }
  }

  // 2. Đọc - Lấy chi tiết sản phẩm theo ID
  Future<Product?> getProductById(int id) async {
    try {
      return await productService.getProduct(id);
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
      return null;
    }
  }

  // 3. Tạo - Thêm sản phẩm mới
  Future<void> addProduct(Product product, String token) async {
    try {
      await productService.addProduct(product, token);
      // Sau khi thêm sản phẩm thành công, tải lại danh sách sản phẩm
      await loadProducts();
    } catch (e) {
      print('Lỗi khi thêm sản phẩm: $e');
    }
  }

  // 4. Cập nhật - Cập nhật sản phẩm theo ID
  Future<void> updateProduct(int id, Product updatedProduct, String token) async {
    try {
      await productService.updateProduct(id, updatedProduct, token);
      await loadProducts();
    } catch (e) {
      print('Lỗi khi cập nhật sản phẩm: $e');
    }
  }


  // 5. Xóa - Xóa sản phẩm theo ID
  Future<void> deleteProduct(int id, String token) async {
    try {
      await productService.deleteProduct(id, token);
      // Sau khi xóa sản phẩm thành công, tải lại danh sách sản phẩm
      await loadProducts();
    } catch (e) {
      print('Lỗi khi xóa sản phẩm: $e');
    }
  }
}

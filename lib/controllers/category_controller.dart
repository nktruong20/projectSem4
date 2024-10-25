import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController {
  final CategoryService categoryService = CategoryService();
  List<Category> categories = [];

  // 1. Đọc - Lấy danh sách category từ backend
  Future<void> loadCategories() async {
    try {
      categories = await categoryService.getCategories();
    } catch (e) {
      print('Lỗi khi tải danh sách danh mục: $e');
    }
  }

  // 2. Đọc - Lấy chi tiết category theo ID
  Future<Category?> getCategoryById(int id) async {
    try {
      return await categoryService.getCategory(id);
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
      return null;
    }
  }

  // 3. Tạo - Thêm category mới
  Future<void> addCategory(Category category, String token) async {
    try {
      await categoryService.addCategory(category, token);
      // Sau khi thêm category thành công, tải lại danh sách category
      await loadCategories();
    } catch (e) {
      print('Lỗi khi thêm danh mục: $e');
    }
  }

  // 4. Cập nhật - Cập nhật category theo ID
  Future<void> updateCategory(int id, Category updatedCategory, String token) async {
    try {
      await categoryService.updateCategory(id, updatedCategory, token);
      await loadCategories();
    } catch (e) {
      print('Lỗi khi cập nhật danh mục: $e');
    }
  }

  // 5. Xóa - Xóa category theo ID
  Future<void> deleteCategory(int id, String token) async {
    try {
      await categoryService.deleteCategory(id, token);
      // Sau khi xóa category thành công, tải lại danh sách category
      await loadCategories();
      print('Danh mục đã được xóa thành công.');
    } catch (e) {
      print('Lỗi khi xóa danh mục: $e');
    }
  }
}

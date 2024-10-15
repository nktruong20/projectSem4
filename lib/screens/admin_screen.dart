import 'package:flutter/material.dart';
import 'package:project_sem4/screens/category_list_screen.dart';
import 'package:project_sem4/screens/product_list_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.pinkAccent, // Màu nền AppBar
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Căn chỉnh padding cho toàn bộ body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch các phần tử theo chiều ngang
          children: [
            // Title hoặc Heading của Dashboard
            Text(
              'Welcome Admin!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30), // Khoảng cách giữa title và các card
            // Card quản lý sản phẩm
            Card(
              elevation: 4, // Đổ bóng cho card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.pinkAccent), // Icon cho card
                title: Text(
                  'Manage Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent), // Mũi tên bên phải
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Khoảng cách giữa các card
            // Card quản lý danh mục
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.category, color: Colors.pinkAccent),
                title: Text(
                  'Manage Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryListScreen()),
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

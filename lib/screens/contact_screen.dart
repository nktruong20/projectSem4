import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.pinkAccent, // Màu nền cho AppBar
      ),
      body: Container(
        color: Colors.white, // Nền màu trắng cho toàn bộ body
        child: Column(
          children: [
            // Header với nền hồng
            Container(
              color: Colors.pinkAccent, // Nền màu hồng cho header
              padding: const EdgeInsets.all(16.0),

            ),
            SizedBox(height: 20.0), // Khoảng cách giữa header và nội dung

            // Hình ảnh liên quan mở rộng ra hai bên
            Container(
              width: MediaQuery.of(context).size.width, // Chiều rộng bằng chiều rộng màn hình
              child: Image.network(
                'https://spacet-release.s3.ap-southeast-1.amazonaws.com/img/blog/2023-10-03/651bea9dc9649b0ef5ad913e.webp', // Sử dụng Image.network để hiển thị ảnh từ URL
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0), // Khoảng cách sau hình ảnh

            // Thông tin liên hệ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: contact@clothingstore.com',
                    style: TextStyle(fontSize: 18.0, color: Colors.black), // Màu chữ đen
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Phone: +1 234 567 890',
                    style: TextStyle(fontSize: 18.0, color: Colors.black), // Màu chữ đen
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),

            // Thêm một nút để gửi email
            ElevatedButton(
              onPressed: () {
                // Hành động khi nhấn nút (ví dụ, gửi email)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent, // Màu nền của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bo góc cho nút
                ),
              ),
              child: Text('Send Us a Message'),
            ),
          ],
        ),
      ),
    );
  }
}

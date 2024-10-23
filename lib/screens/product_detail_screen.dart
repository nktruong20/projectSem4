import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_sem4/screens/cart_screen.dart';
import 'package:project_sem4/services/auth_service.dart';
import 'package:project_sem4/services/cart_service.dart';
import '../models/product_model.dart'; // Nhập model Product

class ProductDetailScreen extends StatelessWidget {
  final Product product; // Nhận thông tin sản phẩm từ HomeProductCard
  final TextEditingController quantityController = TextEditingController(text: "1");
  final AuthService authService = AuthService();
  final CartService cartService = CartService();

  ProductDetailScreen({Key? key, required this.product}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    void _navigateToCartScreen() async {
      String? token = await authService.getToken();
      String? userId = await authService.getUserId();
      if(token != null && userId != null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen(token: token, userId: int.parse(userId))),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _navigateToCartScreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card chứa hình ảnh sản phẩm
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    product.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Tên sản phẩm
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              // Giá sản phẩm
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // Mô tả sản phẩm
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32.0),

              // Nút thêm vào giỏ hàng
              Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          int currentValue = int.parse(quantityController.text);
                          if (currentValue > 1) {
                            quantityController.text = (currentValue - 1).toString(); // Giảm giá trị
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center, // Căn giữa icon
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Tùy chỉnh kích thước
                        ),
                        child: Icon(Icons.remove),
                      ),
                      // Email input
                      Expanded(child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number, // Chỉ cho phép nhập số
                        textAlign: TextAlign.center, // Căn giữa nội dung
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép số
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && int.tryParse(value) != null) {
                            int number = int.parse(value);
                            if (number < 1) {
                              quantityController.text = '1'; // Nếu giá trị nhỏ hơn 1, đặt lại thành 1
                              quantityController.selection = TextSelection.fromPosition(
                                TextPosition(offset: quantityController.text.length),
                              );
                            }
                          }
                        },
                      )),
                      ElevatedButton(
                        onPressed: () {
                          int currentValue = int.parse(quantityController.text);
                          quantityController.text = (currentValue + 1).toString(); // Tăng giá trị
                        },
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center, // Căn giữa icon
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Tùy chỉnh kích thước
                        ),
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text('Add to Cart', style: TextStyle(color: Colors.white )),
                    onPressed: () async {
                      try{
                        String? userId = await authService.getUserId();
                        String? token = await authService.getToken();
                        if(userId != null && token != null){
                          await cartService.addToCart(token, product.id, int.parse(quantityController.text), int.parse(userId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${quantityController.text} Sản phẩm đã được thêm vào giỏ hàng!'),
                              duration: Duration(seconds: 2), // Thời gian hiển thị của thông báo
                            ),
                          );
                        }else{
                          Navigator.pushNamed(context, '/login');
                        }
                      }
                      catch(error){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Thêm vào giỏ hàng không thành công'),
                            duration: Duration(seconds: 2), // Thời gian hiển thị của thông báo
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 12.0,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.pink, // Thay đổi màu nền nút
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

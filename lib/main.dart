import 'package:flutter/material.dart';
import 'package:project_sem4/controllers/product_controller.dart';
import 'package:project_sem4/controllers/cart_controller.dart'; // Thêm import cho CartController
import 'package:project_sem4/models/product_model.dart';
import 'package:project_sem4/screens/admin_screen.dart';
import 'package:project_sem4/screens/category_list_screen.dart';
import 'package:project_sem4/screens/product_list_screen.dart';
import 'package:project_sem4/screens/product_detail_screen.dart';
import 'package:project_sem4/models/user_model.dart';
import 'package:project_sem4/screens/login_screen.dart';
import 'package:project_sem4/screens/signup_screen.dart';
import 'package:project_sem4/screens/home_screen.dart';
import 'package:project_sem4/screens/edit_product_screen.dart';
import 'package:project_sem4/screens/cart_screen.dart';
import 'package:project_sem4/screens/order_screen.dart';
import 'package:project_sem4/screens/order_list_screen.dart'; // Thêm import cho OrderListScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng',
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,  // Ẩn banner debug
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/admin': (context) => AdminScreen(),
        '/home': (context) => HomeScreen(user: User(username: 'Guest', email: '', role: '')),
        '/productList': (context) => ProductListScreen(),
        '/categoryList': (context) => CategoryListScreen(),
        '/editProduct': (context) {
          final Product product = ModalRoute.of(context)?.settings.arguments as Product;
          return EditProductScreen(product: product);
        },
        '/productDetail': (context) {
          final Product product = ModalRoute.of(context)?.settings.arguments as Product;
          return ProductDetailScreen(product: product);
        },
        '/orderList': (context) => OrderListScreen(),  // Thêm route cho OrderListScreen
        // '/cart': (context) {
        //   final CartController cartController = ModalRoute.of(context)?.settings.arguments as CartController;
        //   return CartScreen(cartController: cartController);
        // },
        // '/order': (context) {
        //   return OrderScreen();
        // },
      },
    );
  }
}

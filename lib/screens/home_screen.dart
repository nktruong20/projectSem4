import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_sem4/screens/account_order_screen.dart';
import 'package:project_sem4/screens/cart_screen.dart';
import 'package:project_sem4/screens/login_screen.dart';
import '../controllers/product_controller.dart';
import '../widgets/home_product_card.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'contact_screen.dart';
import 'search_screen.dart'; // Import search screen
import '../controllers/category_controller.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = ProductController();
  final CategoryController categoryController = CategoryController();
  final AuthService authService = AuthService();
  final List<String> bannerImages = [
    'https://intphcm.com/data/upload/banner-thoi-trang-nam.jpg',
    'https://intphcm.com/data/upload/dung-luong-banner-thoi-trang.jpg',
    'https://intphcm.com/data/upload/banner-thoi-trang.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await productController.loadProducts();
    setState(() {});
  }

  Future<void> _logout() async {
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToCartScreen() async {
    String? token = await authService.getToken();
    String? userId = await authService.getUserId();

    if (token != null && userId != null) {
      // User is logged in, navigate to CartScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen(token: token, userId: int.parse(userId))),
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _navigateToContactScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen()),
    );
  }

  void _navigateToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()), // Chuyển tới màn hình tìm kiếm
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clothing Store',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false, // Không hiển thị nút quay lại
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _navigateToCartScreen, // Chuyển tới trang giỏ hàng
          ),
          _buildUserInfo(), // Hiển thị tên người dùng và icon logout
        ],
      ),

      body: Column(
        children: [
          // Taskbar với menu chỉ có Contact và Tìm kiếm
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            color: Colors.pink[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _navigateToContactScreen,
                  child: Text(
                    'Contact',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToSearchScreen, // Điều hướng đến trang tìm kiếm
                  child: Row(
                    children: [
                      Text(
                        'Tìm kiếm',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Khoảng trống trước banner
          SizedBox(height: 10.0),

          // Banner chuyển động
          Container(
            height: 150.0,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
              items: bannerImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Tiêu đề cho danh mục sản phẩm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sản phẩm',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
          ),

          // Danh sách sản phẩm (2 sản phẩm trên 1 hàng)
          Expanded(
            child: productController.products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số lượng sản phẩm trên một hàng
                childAspectRatio: 0.6, // Tỷ lệ chiều rộng và chiều cao của sản phẩm
                crossAxisSpacing: 10.0, // Khoảng cách giữa các sản phẩm
                mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
              ),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return HomeProductCard(product: product); // Sản phẩm được hiển thị trong lưới
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị thông tin người dùng và icon logout
  Widget _buildUserInfo() {
    return FutureBuilder<String?>( // FutureBuilder để lấy tên người dùng
      future: authService.getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                TextButton(
                  onPressed:  () async {
                    String? token = await authService.getToken();
                    String? userId = await authService.getUserId();
                    if (token != null && userId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => orderAccountScreen(token: token, userId: int.parse(userId))),
                      );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  child: Text(snapshot.data!, style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white), // Icon logout
                  onPressed: _logout, // Thực hiện đăng xuất
                ),
              ],
            ),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.person, color: Colors.white), // Icon chuyển tới trang đăng nhập
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          );
        }
      },
    );
  }
}


// xong home
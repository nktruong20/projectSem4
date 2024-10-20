import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_sem4/screens/cart_screen.dart';
import '../controllers/product_controller.dart';
import '../widgets/home_product_card.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'admin_screen.dart';
import 'contact_screen.dart';
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

  String? _selectedCategory;

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

  void _navigateToAdminScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminScreen()),
    );
  }

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

  void _navigateToContactScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen()),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            onPressed: _navigateToAdminScreen,
          ),
          _buildUserDropdown(),
        ],
      ),
      body: Column(
        children: [
          // Taskbar với các menu
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            color: Colors.pink[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/home');
                  },
                  child: Text(
                    'Home',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
                DropdownButton<String>(
                  hint: const Text('Danh mục', style: TextStyle(color: Colors.pink)),
                  value: _selectedCategory,
                  items: categoryController.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name, style: TextStyle(color: Colors.pink)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: _navigateToContactScreen,
                  child: Text(
                    'Contact',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),

          // Khoảng trống trước banner
          SizedBox(height: 10.0),

          // Banner chuyển động
          Container(
            height: 150.0, // Độ dài của banner
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
              'Danh mục sản phẩm',
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

  // Hàm để tạo dropdown cho người dùng
  Widget _buildUserDropdown() {
    return FutureBuilder<String?>(
      future: authService.getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Row(
            children: [
              Text(snapshot.data!, style: TextStyle(fontSize: 20, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                iconSize: 24, // Đặt kích thước icon là 40px
                onPressed: _navigateToCartScreen,
              ),
              IconButton(
                icon: const Icon(Icons.login, color: Colors.white),
                  iconSize: 24, // Đặt kích thước icon là 40px
                  onPressed: () {
                  Navigator.pushNamed(context, '/login');
                  },
              )
            ],
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.login, color: Colors.white),
            iconSize: 24, // Đặt kích thước icon là 40px
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          );
        }
      },
    );
  }
}

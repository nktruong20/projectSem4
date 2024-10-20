import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  final String token;
  final int userId;

  const CartScreen({required this.token, required this.userId});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = CartService().getCart(widget.token, widget.userId);

  }

  void _deleteCartItem(int id) {
    CartService().deleteCartItem(widget.token, id).then((_) {
      setState(() {
        _cartItems = CartService()
            .getCart(widget.token, widget.userId); // Refresh cart items
      });
    });
  }

  int getTotalCartQuantity(List<CartItem> cartItem) {
    int totalQuantity = 0;

    cartItem.forEach((item) {
      totalQuantity = totalQuantity + item.quantity;

    });
    return totalQuantity;
  }

  double getTotalCartPrice(List<CartItem> cartItem) {
    double totalPrice = 0;
    cartItem.forEach((item) {

      totalPrice = totalPrice + item.price;
    });
    return totalPrice;
  }


  void _placeOrder() {
    // Logic to place order goes here.
    // You will need to implement the place order service and call it here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ Hàng', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItems,
        builder: (context, snapshot) {
          print(snapshot.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Giỏ hàng của bạn trống.'));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Row(
                    children: [
                      Image(
                        width: 80,
                        height: 80,
                        image: NetworkImage(item.imageUrl), // Đường dẫn tới ảnh
                        fit: BoxFit
                            .cover, // Tùy chỉnh để ảnh được fit vào vùng chứa
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(item.name),
                              Text('Giá: \$${item.price} x ${item.quantity}')
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )
                    ],
                  );
                  ListTile(
                    title: Text(item.name),
                    subtitle: Text('Giá: \$${item.price} x ${item.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCartItem(item.id),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Tổng số lượng: ${getTotalCartQuantity(snapshot.data!)}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text('Tổng tiê: ${getTotalCartPrice(snapshot.data!)}',  style: TextStyle(fontSize: 18),)
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút checkout
                        },
                        child: Text('Checkout'),
                      ),
                    ],
                  )),
                ),
              )
            ],
          );
        },
      ),

    );
  }
}

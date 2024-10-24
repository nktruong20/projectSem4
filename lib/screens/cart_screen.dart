import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_sem4/screens/checkout_screen.dart';
import 'package:project_sem4/services/auth_service.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import 'package:project_sem4/screens/checkout_screen.dart'; // Đảm bảo rằng đường dẫn là chính xác


class CartScreen extends StatefulWidget {
  final String token;
  final int userId;

  CartScreen({required this.token, required this.userId});

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
        _cartItems = CartService().getCart(widget.token, widget.userId); // Refresh cart items
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa thành công'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  int getTotalCartQuantity(List<CartItem> cartItem) {
    int totalQuantity = 0;

    cartItem.forEach((item) {
      totalQuantity += item.quantity;
    });
    return totalQuantity;
  }

  double getTotalCartPrice(List<CartItem> cartItem) {
    double totalPrice = 0;
    cartItem.forEach((item) {
      totalPrice += item.price * item.quantity;
    });
    return totalPrice;
  }

  void _navigateToCheckout() async {
    String? userName = await AuthService().getUsername();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => checkoutScreen(
            token: widget.token,
            userId: widget.userId,
            userName: '${userName}',
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ Hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Giỏ hàng của bạn trống.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
          return Stack(
            children: [
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  final TextEditingController quantityController =
                  TextEditingController(text: "${item.quantity}");
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Đơn Giá: \$${item.price} ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'x ${item.quantity}',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        int currentValue =
                                        int.parse(quantityController.text);
                                        if (currentValue > 0) {
                                          quantityController.text =
                                              (currentValue - 1).toString();
                                        }
                                      },
                                      icon: Icon(Icons.remove),
                                      iconSize: 20,
                                      color: Colors.pinkAccent,
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: TextField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.pink[50],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        int currentValue =
                                        int.parse(quantityController.text);
                                        if (currentValue >= 0) {
                                          quantityController.text =
                                              (currentValue + 1).toString();
                                        }
                                      },
                                      icon: Icon(Icons.add),
                                      iconSize: 20,
                                      color: Colors.pinkAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _deleteCartItem(item.id);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.redAccent,
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (item.quantity !=
                                      int.parse(quantityController.text) &&
                                      int.parse(quantityController.text) > 0) {
                                    try {
                                      String? userId =
                                      await AuthService().getUserId();
                                      String? token =
                                      await AuthService().getToken();
                                      if (userId != null && token != null) {
                                        await CartService().addToCart(
                                            token,
                                            item.productId,
                                            int.parse(quantityController.text) -
                                                item.quantity,
                                            int.parse(userId));
                                        setState(() {
                                          _cartItems = CartService().getCart(
                                              widget.token, widget.userId);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Cập nhật giỏ hàng thành công!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushNamed(context, '/login');
                                      }
                                    } catch (error) {
                                      setState(() {
                                        _cartItems = CartService().getCart(
                                            widget.token, widget.userId);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Cập nhật giỏ hàng không thành công!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } else if (int.parse(
                                      quantityController.text) ==
                                      0) {
                                    _deleteCartItem(item.id);
                                  }
                                },
                                icon: Icon(Icons.save),
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
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
                  color: Colors.pinkAccent.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng số lượng: ${getTotalCartQuantity(snapshot.data!)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tổng tiền: \$${getTotalCartPrice(snapshot.data!)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _navigateToCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

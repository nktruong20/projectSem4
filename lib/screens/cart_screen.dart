import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_sem4/services/auth_service.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

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
        _cartItems = CartService()
            .getCart(widget.token, widget.userId); // Refresh cart items
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Xóa thành công'),
          duration: Duration(
              seconds:
              2), // Thời gian hiển thị của thông báo
        ),
      );
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
      totalPrice = totalPrice + item.price * item.quantity;
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
        title: Text(
          'Giỏ Hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItems,
        builder: (context, snapshot) {
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
                  final TextEditingController quantityController =
                      TextEditingController(text: "${item.quantity}");
                  return Row(
                    children: [
                      Image(
                        width: 80,
                        height: 80,
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Đơn Giá: \$${item.price} ',
                                    style: TextStyle(color: Colors.black), // Bạn có thể tùy chỉnh màu sắc ở đây
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
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    int currentValue =
                                        int.parse(quantityController.text);
                                    if (currentValue > 0) {
                                      quantityController.text =
                                          (currentValue - 1)
                                              .toString(); // Giảm giá trị
                                    }
                                  },
                                  icon: Icon(Icons.remove),
                                  iconSize: 15,
                                ),
                                SizedBox(
                                  width:
                                      30, // Giới hạn chiều rộng của TextField
                                  height: 30, // Chiều cao của TextField
                                  child: TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.7),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              5), // Giảm padding trong TextField
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty &&
                                          int.tryParse(value) != null) {
                                        int number = int.parse(value);
                                        if (number < 0) {
                                          quantityController.text = '0';
                                          quantityController.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                                offset: quantityController
                                                    .text.length),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      int currentValue =
                                          int.parse(quantityController.text);
                                      if (currentValue >= 0) {
                                        quantityController.text =
                                            (currentValue + 1)
                                                .toString(); // Tăng giá trị
                                      }
                                    },
                                    icon: Icon(Icons.add),
                                    iconSize: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(children: [
                        IconButton(
                          onPressed: () {
                            _deleteCartItem(item.id);
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
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
                                    _cartItems = CartService()
                                        .getCart(widget.token, widget.userId);
                                    setState(() {
                                      _cartItems = CartService()
                                          .getCart(widget.token, widget.userId);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Cập nhật giỏ hàng thành công!'),
                                        duration: Duration(
                                            seconds:
                                                2), // Thời gian hiển thị của thông báo
                                      ),
                                    );
                                  } else {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                } catch (error) {
                                  _cartItems = CartService()
                                      .getCart(widget.token, widget.userId);
                                  setState(() {
                                    _cartItems = CartService()
                                        .getCart(widget.token, widget.userId);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Cập nhật giỏ hàng không thành công!'),
                                      duration: Duration(
                                          seconds:
                                              2), // Thời gian hiển thị của thông báo
                                    ),
                                  );
                                }
                              }else if ( int.parse(quantityController.text) == 0){
                                _deleteCartItem(item.id);
                              }
                            },
                            icon: Icon(Icons.save),
                            color: Colors.green)
                      ])
                    ],
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
                          Text(
                            'Tổng tiền: ${getTotalCartPrice(snapshot.data!)}',
                            style: TextStyle(fontSize: 18),
                          )
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

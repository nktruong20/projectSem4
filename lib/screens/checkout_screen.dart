import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_sem4/models/cart.dart';
import 'package:project_sem4/models/user_model.dart';
import 'package:project_sem4/screens/cart_screen.dart';
import 'package:project_sem4/screens/home_screen.dart';
import 'package:project_sem4/services/auth_service.dart';
import 'package:project_sem4/services/cart_service.dart';
import 'package:project_sem4/services/order_service.dart';

class checkoutScreen extends StatefulWidget {
  final String token;
  final int userId;
  final String userName;

  checkoutScreen(
      {required this.token, required this.userId, required this.userName});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<checkoutScreen> {
  late Future<List<CartItem>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = CartService().getCart(widget.token, widget.userId);
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

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: widget.userName);
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thanh toán',
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

            return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    // Phần Container: chứa danh sách giỏ hàng
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                                'Tổng tiền: \$${getTotalCartPrice(snapshot.data!)}'),
                            Text(
                                'Tổng số lượng: ${getTotalCartQuantity(snapshot.data!)}')
                          ],
                        )),
                    // Phần Stack: chồng các thành phần khác nếu cần
                    Text(
                      "Chi tiết sản phẩm:",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1, // Chiếm 1/5 chiều cao
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          final TextEditingController quantityController =
                              TextEditingController(text: "${item.quantity}");
                          return Row(
                            children: [
                              Text('${item.quantity} x ${item.name} = '),
                              Text(
                                '${item.quantity} x \$${item.price}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    // Phần Form: Nhập thông tin thanh toán
                    Expanded(
                      flex: 6, // Chiếm 1/5 chiều cao
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Tên người nhận',
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Số điện thoại',
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Địa chỉ giao hàng',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width:
                                  double.infinity, // Chiều rộng full của button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink, // Nền màu hồng
                                  foregroundColor:
                                      Colors.white, // Màu chữ trắng
                                ),
                                onPressed: () async {
                                  // Kiểm tra và xử lý thông tin submit
                                  String name = nameController.text;
                                  String phone = phoneController.text;
                                  String address = addressController.text;

                                  // Thực hiện các hành động khi submit (ví dụ như gửi form)
                                  if (name.isNotEmpty &&
                                      phone.isNotEmpty &&
                                      address.isNotEmpty) {
                                    try {
                                      await OrderService().PostOrder(
                                          widget.token,
                                          snapshot.data!,
                                          getTotalCartPrice(snapshot.data!),
                                          address,
                                          phone);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Đặt hàng thành công', style: TextStyle(fontSize: 18, color: Colors.green),),
                                          duration: Duration(
                                              seconds:
                                                  3), // Thời gian hiển thị của thông báo
                                        ),
                                      );

                                      String? role = await AuthService().getRole();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen(user: User(username: widget.userName, email: '', role: '${role}'))),
                                            (route) => false, // Xóa tất cả các route trong stack
                                      );

                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Đặt hàng không thành công'),
                                          duration: Duration(
                                              seconds:
                                                  2), // Thời gian hiển thị của thông báo
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Vui lòng điền đầy đủ thông tin.'),
                                        duration: Duration(
                                            seconds:
                                                2), // Thời gian hiển thị của thông báo
                                      ),
                                    );
                                  }
                                },
                                child: Text('Xác nhận và Thanh toán'),
                              ),
                            )
                            // Các trường khác cho thông tin thanh toán
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          },
        ));
  }
}

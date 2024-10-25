import 'package:flutter/material.dart';
import 'package:project_sem4/models/cart.dart';
import 'package:project_sem4/models/order.dart';
import 'package:project_sem4/screens/order_detail.dart';
import 'package:project_sem4/services/auth_service.dart';
import 'package:project_sem4/services/cart_service.dart';
import 'package:project_sem4/services/order_service.dart';

class orderAccountScreen extends StatefulWidget {
  final String token;
  final int userId;

  orderAccountScreen({required this.token, required this.userId});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<orderAccountScreen> {
  late Future<List<Order>> _orderItems;

  @override
  void initState() {
    super.initState();
    _orderItems = OrderService().getOrders(widget.token, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Đơn hàng',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
        ),
        body: FutureBuilder<List<Order>>(
          future: _orderItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Có lỗi xảy ra!'));
            }

            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Container(
                      padding: EdgeInsets.only(
                          bottom: 8.0, top: 8), // Padding phía dưới
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Màu của đường kẻ
                            width: 1.0, // Độ dày của đường kẻ
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đơn hàng: ${item.id}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ngày tạo: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                item.createdAt.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Người nhận: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                item.username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Địa chỉ: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                item.address,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Số điện thoại: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                item.phone,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tổng tiền: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '\$${item.totalPrice}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.pinkAccent),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailScreen(
                                          orderId: item.id,
                                          token: widget.token,
                                          totalPrice: item.totalPrice,
                                        address: item.address,
                                        date: item.createdAt.toString(),
                                        name: item.username,
                                        phone: item.phone,
                                      ),
                                    ));
                              },
                              child: Text(
                                'Chi tiết đơn hàng',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  foregroundColor: Colors.white)),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ));
                },
              ),
            );
          },
        ));
  }
}

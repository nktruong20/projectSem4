import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_sem4/models/order_item.dart';
import 'package:project_sem4/services/order_service.dart';
import '../models/cart.dart';

class OrderDetailScreen extends StatefulWidget {
  final String token;
  final int orderId;
  final double totalPrice;
  final String name;
  final String address;
  final String phone;
  final String date;

  OrderDetailScreen(
      {required this.token,
      required this.orderId,
      required this.totalPrice,
      required this.name,
      required this.phone,
      required this.address,
      required this.date});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<List<OrderItem>> _orderItems;

  @override
  void initState() {
    super.initState();
    _orderItems = OrderService().getOrderItems(widget.orderId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    getTotalQuantity(List<OrderItem> orderItems) {
      int totalQuantity = 0;
      orderItems.forEach((item) {
        totalQuantity += item.quantity;
      });
      return totalQuantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đơn hàng #${widget.orderId}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _orderItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra!'));
          }
          return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ngày tạo: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                widget.date,
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
                                widget.name,
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
                                widget.address,
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
                                widget.phone,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Số lượng: ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${getTotalQuantity(snapshot.data!)}',
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
                                '\$${widget.totalPrice}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.pinkAccent),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Sản phẩm: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
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

                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.productImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        item.productName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(0),
                                      ),
                                    ),

                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Đơn Giá: \$${item.price / item.quantity} ',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Tổng tiền'),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '\$${item.price}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ))
              ]));
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderScreen extends StatefulWidget {
  final String token;

  OrderScreen({required this.token});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = OrderService().getOrders(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn Hàng'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Bạn chưa có đơn hàng nào.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              return ListTile(
                title: Text('Đơn hàng #${order.id}'),
                subtitle: Text('Tổng giá: \$${order.totalPrice}\nTrạng thái: ${order.status}'),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_sem4/controllers/order_controller.dart';
import 'package:project_sem4/models/order.dart';

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderController()..fetchOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: Consumer<OrderController>(
          builder: (context, orderController, child) {
            if (orderController.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (orderController.errorMessage.isNotEmpty) {
              return Center(child: Text('Lỗi: ${orderController.errorMessage}', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)));
            }

            if (orderController.orders.isEmpty) {
              return Center(child: Text('Không có đơn hàng nào.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)));
            }

            return ListView.builder(
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                Order order = orderController.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      'Đơn hàng số: ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Tổng giá: \$${order.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.bold), // Đậm hơn
                        ),
                        Text(
                          'Địa chỉ: ${order.address}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Đậm hơn
                        ),
                        Text(
                          'Điện thoại: ${order.phone}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Đậm hơn
                        ),
                        Text(
                          'Người dùng: ${order.username}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Đậm hơn
                        ),
                      ],
                    ),

                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

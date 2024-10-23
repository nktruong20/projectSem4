// import 'package:flutter/material.dart';
// import '../models/cart.dart';
//
// class CartCard extends StatelessWidget {
//   final CartItem cartItem;
//   final Function onIncrement;
//   final Function onDecrement;
//
//   CartCard({
//     required this.cartItem,
//     required this.onIncrement,
//     required this.onDecrement,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Text(cartItem.productName),
//             Spacer(),
//             IconButton(
//               icon: Icon(Icons.remove),
//               onPressed: () => onDecrement(),
//             ),
//             Text(cartItem.quantity.toString()),
//             IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () => onIncrement(),
//             ),
//             Spacer(),
//             Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

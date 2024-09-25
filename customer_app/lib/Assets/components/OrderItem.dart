import 'package:customer_app/Assets/Model/OrderModel.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderDetail, // Replace with order title
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                order.customerId as String, // Replace with customer name
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.orderDate} ${order.orderTime}', // Format date and time
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Text(
            'Status: ${order.orderStatus}', // Dynamic status
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

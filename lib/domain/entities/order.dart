import 'package:accesories_store_flutter/domain/entities/cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime purchaseDate;
  final String status;
  final Map<String, dynamic> billingInfo;
  final String paymentMethod;


  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.purchaseDate,
    required this.status,
    required this.billingInfo,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.product.id,
        'name': item.product.nombre,
        'quantity': item.quantity,
        'price': item.product.precio,
      }).toList(),
      'totalAmount': totalAmount,
      'purchaseDate': purchaseDate,
      'status': status,
      'billingInfo': billingInfo,
      'paymentMethod': paymentMethod,
    };
  }
}

import 'package:accesories_store_flutter/domain/entities/order.dart';

abstract class OrderRepository {
  Future<void> placeOrder(Order order);
} 
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:accesories_store_flutter/domain/entities/order.dart';
import 'package:accesories_store_flutter/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepositoryImpl(this._firestore);

  @override
  Future<void> placeOrder(Order order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print('Error al guardar la orden en Firestore: $e');
      rethrow; 
    }
  }
} 
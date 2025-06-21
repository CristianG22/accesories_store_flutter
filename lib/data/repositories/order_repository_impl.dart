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
      // Manejo de errores específico del repositorio
      print('Error al guardar la orden en Firestore: $e');
      rethrow; // Relanzar para que la capa superior (el notifier) pueda manejarlo
    }
  }
} 
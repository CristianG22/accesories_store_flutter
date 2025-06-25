import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/data/repositories/order_repository_impl.dart';
import 'package:accesories_store_flutter/domain/entities/order.dart';
import 'package:accesories_store_flutter/domain/repositories/order_repository.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';


final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(FirebaseFirestore.instance);
});


enum CheckoutState { initial, loading, success, error }


class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final OrderRepository _orderRepository;
  final Function _clearCartCallback;

  CheckoutNotifier(this._orderRepository, this._clearCartCallback) : super(CheckoutState.initial);

  Future<void> placeOrder(Order order) async {
    state = CheckoutState.loading;
    try {
      await _orderRepository.placeOrder(order);
      _clearCartCallback(); 
      state = CheckoutState.success;
    } catch (e) {
      state = CheckoutState.error;
    }
  }

  void reset() {
    state = CheckoutState.initial;
  }
}


final checkoutNotifierProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  
  final clearCartCallback = ref.read(cartProvider.notifier).clearCart;
  return CheckoutNotifier(orderRepository, clearCartCallback);
}); 
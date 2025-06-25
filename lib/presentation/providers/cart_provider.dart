import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/domain/models/cart_model.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'cart_notifier.dart';

class CartNotifier extends StateNotifier<CartModel> {
  CartNotifier() : super(CartModel()); 

  void addItem(Producto product, int quantity) {
    
    state.addItem(product, quantity);
    
    state = CartModel.fromExisting(state);
  }

  void removeItem(String productId) {
    state.removeItem(productId);
    state = CartModel.fromExisting(state);
  }

  void updateItemQuantity(String productId, int newQuantity) {
    state.updateItemQuantity(productId, newQuantity);
    state = CartModel.fromExisting(state);
  }

  void clearCart() {
    state.clearCart();
    
    state = CartModel();
  }
}


final cartProvider = StateNotifierProvider<CartNotifier, CartModel>((ref) {
  return CartNotifier();
}); 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/domain/models/cart_model.dart';
import 'package:accesories_store_flutter/entities/product.dart';

// Este StateNotifier manejará el estado del carrito
class CartNotifier extends StateNotifier<CartModel> {
  CartNotifier() : super(CartModel()); // Inicializa con un carrito vacío

  void addItem(Producto product, int quantity) {
    // Modifica el estado actual del CartModel
    state.addItem(product, quantity);
    // Crea una nueva instancia del CartModel a partir del estado modificado, lo que dispara la notificación
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
    // Asignar una nueva instancia vacía para notificar
    state = CartModel();
  }
}

// El proveedor que expondrá nuestro CartNotifier
final cartProvider = StateNotifierProvider<CartNotifier, CartModel>((ref) {
  return CartNotifier();
}); 
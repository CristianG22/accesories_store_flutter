import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/entities/cart_item.dart';
import 'package:accesories_store_flutter/entities/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Producto producto) {
    final existingItemIndex = state.indexWhere(
      (item) => item.product.nombre == producto.nombre,
    );

    if (existingItemIndex != -1) {
      // Product already in cart, increase quantity
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingItemIndex)
            CartItem(
              product: state[i].product,
              quantity: state[i].quantity + 1,
            )
          else
            state[i],
      ];
    } else {
      // Product not in cart, add new item
      state = [...state, CartItem(product: producto)];
    }
  }

  void removeProduct(CartItem cartItem) {
    state =
        state
            .where((item) => item.product.nombre != cartItem.product.nombre)
            .toList();
  }

  void increaseQuantity(CartItem cartItem) {
    state = [
      for (final item in state)
        if (item.product.nombre == cartItem.product.nombre)
          CartItem(product: item.product, quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      state = [
        for (final item in state)
          if (item.product.nombre == cartItem.product.nombre)
            CartItem(product: item.product, quantity: item.quantity - 1)
          else
            item,
      ];
    } else {
      // If quantity is 1, remove the item
      removeProduct(cartItem);
    }
  }

  double getTotal() {
    return state.fold(
      0.0,
      (total, item) => total + (item.product.precio * item.quantity),
    );
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

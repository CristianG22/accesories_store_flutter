import 'package:accesories_store_flutter/entities/product.dart';

class CartItem {
  final Producto product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Método para copiar el item y cambiar la cantidad (útil para inmutabilidad)
  CartItem copyWith({Producto? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

import 'package:accesories_store_flutter/domain/entities/product.dart';

class CartItem {
  final Producto product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({Producto? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

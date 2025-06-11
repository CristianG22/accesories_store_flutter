import 'package:accesories_store_flutter/entities/product.dart';

class CartItem {
  final Producto producto;
  int quantity;

  CartItem({required this.producto, this.quantity = 1});
}

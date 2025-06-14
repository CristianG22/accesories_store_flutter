import 'package:accesories_store_flutter/entities/product.dart';
import 'package:accesories_store_flutter/entities/cart_item.dart';

class CartModel {
  final List<CartItem> _items;

  CartModel._(this._items);

  CartModel() : _items = [];

  CartModel.fromExisting(CartModel other) : _items = List.from(other._items);

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(Producto product, int quantity) {
    // Buscar si el producto ya está en el carrito
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      // Si existe, actualizar la cantidad
      _items[existingItemIndex] = _items[existingItemIndex].copyWith(
        quantity: _items[existingItemIndex].quantity + quantity,
      );
    } else {
      // Si no existe, añadirlo como un nuevo item
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  void updateItemQuantity(String productId, int newQuantity) {
    final itemIndex = _items.indexWhere((item) => item.product.id == productId);
    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(itemIndex); // Eliminar si la cantidad es 0 o menos
      } else {
        _items[itemIndex] = _items[itemIndex].copyWith(quantity: newQuantity);
      }
    }
  }

  double getTotalPrice() {
    return _items.fold(0.0, (total, current) => total + (current.product.precio * current.quantity));
  }

  int getTotalItemsCount() {
    return _items.fold(0, (total, current) => total + current.quantity);
  }

  void clearCart() {
    _items.clear();
  }
} 
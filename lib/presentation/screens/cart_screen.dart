import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';
import 'package:accesories_store_flutter/entities/cart_item.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartModel = ref.watch(cartProvider);
    final total = cartModel.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850], // Fondo oscuro similar a la imagen
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Flecha de regreso blanca
          onPressed: () {
            // Siempre intenta ir a la pantalla de categorías si no puede hacer pop
            context.go('/categories');
          },
        ),
        title: Text(
          'Carrito',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ), // Título blanco y negrita
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black, // Fondo negro para el cuerpo
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartModel.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cartModel.items[index];
                  return _CartItemWidget(cartItem: cartItem);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Total de la compra',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ), // Texto blanco
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}', // Mostrar total con 2 decimales
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.cyanAccent,
                    ), // Color turquesa similar a la imagen
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:
                    cartModel.items.isEmpty
                        ? null
                        : () {
                          context.push('/checkout');
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent, // Color de fondo turquesa
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Continuar compra',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemWidget extends ConsumerWidget {
  final CartItem cartItem;

  const _CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Image.network(
              cartItem.product.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, color: Colors.white70),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 2, // Ajustado para dar más espacio al nombre del producto
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  // overflow: TextOverflow.ellipsis, // Se eliminó para permitir el nombre completo
                ),
                SizedBox(height: 8),
                Text(
                  '\$${cartItem.product.precio.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            // Expanded for quantity controls
            flex: 2, // Ajustado para mantener proporción con el nombre
            child: Row(
              children: [
                SizedBox(
                  width: 24, // Fixed width
                  height: 24, // Fixed height
                  child: IconButton(
                    icon: Icon(Icons.remove, color: Colors.cyanAccent),
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateItemQuantity(
                            cartItem.product.id,
                            cartItem.quantity - 1,
                          );
                    },
                    padding: EdgeInsets.zero, // Still zero padding
                    visualDensity:
                        VisualDensity.compact, // Still compact visual density
                  ),
                ),
                Flexible(
                  // Ensure the quantity text is flexible
                  child: Text(
                    cartItem.quantity
                        .toString(), // Muestra solo el número de la cantidad
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ), // Reduced font size
                  ),
                ),
                SizedBox(
                  width: 24, // Fixed width
                  height: 24, // Fixed height
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.cyanAccent),
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateItemQuantity(
                            cartItem.product.id,
                            cartItem.quantity + 1,
                          );
                    },
                    padding: EdgeInsets.zero, // Still zero padding
                    visualDensity:
                        VisualDensity.compact, // Still compact visual density
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // Fixed width for delete button
            width: 24, // Fixed width
            height: 24, // Fixed height
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.cyanAccent),
              onPressed: () {
                ref.read(cartProvider.notifier).removeItem(cartItem.product.id);
              },
              padding: EdgeInsets.zero, // Still zero padding
            ),
          ),
        ],
      ),
    );
  }
}

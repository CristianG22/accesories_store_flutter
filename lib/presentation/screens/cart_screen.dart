import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_notifier.dart';
import 'package:accesories_store_flutter/entities/cart_item.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.getTotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850], // Fondo oscuro similar a la imagen
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Flecha de regreso blanca
          onPressed: () => Navigator.of(context).pop(),
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
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
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
                  Text(
                    'Total de la compra',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ), // Texto blanco
                  ),
                  Text(
                    '\$\${total.toStringAsFixed(3)}', // Mostrar total con 3 decimales
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
                onPressed: () {
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
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            child: Image.network(
              cartItem.producto.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, color: Colors.white70),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.producto.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\$\${cartItem.producto.precio.toStringAsFixed(3)}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.cyanAccent),
                onPressed: () {
                  cartNotifier.decreaseQuantity(cartItem);
                },
                visualDensity: VisualDensity.compact,
              ),
              Text(
                '\${cartItem.quantity}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.cyanAccent),
                onPressed: () {
                  cartNotifier.increaseQuantity(cartItem);
                },
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.cyanAccent),
            onPressed: () {
              cartNotifier.removeProduct(cartItem);
            },
          ),
        ],
      ),
    );
  }
}

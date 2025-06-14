import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  Future<void> _confirmPurchase(BuildContext context, WidgetRef ref) async {
    final cartModel = ref.read(cartProvider);
    final cartItems = cartModel.items;

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El carrito está vacío. Agrega productos antes de confirmar la compra.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Simulando la obtención de datos de facturación y método de pago (deberías obtenerlos de campos de texto reales)
      final Map<String, dynamic> billingInfo = {
        'nombre': 'Usuario',
        'apellido': 'Prueba',
        'email': 'usuario.prueba@example.com',
        'direccion': 'Calle Ficticia 123',
      };

      final String paymentMethod = 'Mercado Pago';

      final List<Map<String, dynamic>> itemsData =
          cartItems
              .map(
                (item) => {
                  'productId': item.product.id,
                  'name': item.product.nombre,
                  'quantity': item.quantity,
                  'price': item.product.precio,
                },
              )
              .toList();

      final double totalAmount = cartItems.fold(
        0.0,
        (sum, item) => sum + (item.product.precio * item.quantity),
      );

      await FirebaseFirestore.instance.collection('orders').add({
        'userId':
            'guest_user', // Puedes reemplazar esto con el ID de usuario real si tienes autenticación
        'billingInfo': billingInfo,
        'paymentMethod': paymentMethod,
        'items': itemsData,
        'totalAmount': totalAmount,
        'purchaseDate': Timestamp.now(),
        'status': 'pending',
      });

      // Limpiar el carrito después de una compra exitosa
      ref.read(cartProvider.notifier).clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Compra confirmada y guardada en Firestore!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al confirmar la compra: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error saving order to Firestore: $e'); // Para depuración
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartModel = ref.watch(cartProvider);
    final cartItems = cartModel.items;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),

      bottomNavigationBar: CustomBottomNav(),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'Datos de facturación',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nombre',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Text(
              'Apellido',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Text(
              'Email',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Text(
              'Dirección',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Método de pago',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mercado Pago',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Resumen de compra',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (cartItems.isEmpty)
              const Text(
                'El carrito está vacío.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    cartItems.map((item) {
                      return Text(
                        '${item.product.nombre} x ${item.quantity} (\$${(item.product.precio * item.quantity).toStringAsFixed(3)})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }).toList(),
              ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await _confirmPurchase(context, ref);
                },
                child: const Text(
                  'Confirmar compra',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

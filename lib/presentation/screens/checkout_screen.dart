import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

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
                children: cartItems.map((item) {
                  return Text(
                    '${item.product.nombre} x ${item.quantity} (\$${(item.product.precio * item.quantity).toStringAsFixed(3)})',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                onPressed: () {
                  // Acción de confirmar compra: por ahora, solo muestra un SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Compra confirmada (funcionalidad completa en desarrollo).'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Aquí podrías añadir la lógica para procesar el pago y vaciar el carrito
                  // ref.read(cartProvider.notifier).clearCart();
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

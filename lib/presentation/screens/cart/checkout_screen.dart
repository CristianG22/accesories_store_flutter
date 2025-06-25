import 'package:accesories_store_flutter/domain/entities/cart_item.dart';
import 'package:accesories_store_flutter/domain/entities/order.dart';
import 'package:accesories_store_flutter/presentation/providers/order_providers.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  void _handleCheckoutState(CheckoutState state, BuildContext context, WidgetRef ref) {
    if (state == CheckoutState.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Compra realizada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
     
      ref.read(checkoutNotifierProvider.notifier).reset();
      context.go('/');
    } else if (state == CheckoutState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hubo un error al procesar la compra.'),
          backgroundColor: Colors.red,
        ),
      );
      ref.read(checkoutNotifierProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutNotifierProvider);

    ref.listen(checkoutNotifierProvider, (_, state) {
      _handleCheckoutState(state, context, ref);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNav(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            _buildSectionTitle('Datos de facturación'),
            _buildInfoText('Nombre: Usuario Prueba'),
            _buildInfoText('Email: usuario.prueba@example.com'),
            _buildInfoText('Dirección: Calle Ficticia 123'),
            const SizedBox(height: 30),
            _buildSectionTitle('Método de pago'),
            _buildInfoText('Mercado Pago'),
            const SizedBox(height: 30),
            _buildSectionTitle('Resumen de compra'),
            const SizedBox(height: 10),
            if (cart.items.isEmpty)
              _buildInfoText('El carrito está vacío.')
            else
              _buildOrderSummary(cart.items),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  disabledBackgroundColor: Colors.grey.shade700,
                ),
                onPressed: (cart.items.isEmpty || checkoutState == CheckoutState.loading)
                    ? null
                    : () {
                        
                        final order = Order(
                          id: '', 
                          userId: 'guest_user', 
                          items: cart.items,
                          totalAmount: cart.getTotalPrice(),
                          purchaseDate: DateTime.now(),
                          status: 'pending',
                          billingInfo: const { 
                            'nombre': 'Usuario Prueba',
                            'email': 'usuario.prueba@example.com',
                            'direccion': 'Calle Ficticia 123',
                          },
                          paymentMethod: 'Mercado Pago',
                        );
                        ref.read(checkoutNotifierProvider.notifier).placeOrder(order);
                      },
                child: (checkoutState == CheckoutState.loading)
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Confirmar compra', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }

  Widget _buildOrderSummary(List<CartItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return _buildInfoText(
          '${item.product.nombre} x ${item.quantity} (\$${(item.product.precio * item.quantity).toStringAsFixed(2)})',
        );
      }).toList(),
    );
  }
}

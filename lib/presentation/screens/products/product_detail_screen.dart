import 'package:flutter/material.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';
import 'package:accesories_store_flutter/presentation/providers/products_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: productAsyncValue.when(
        data: (producto) => _ProductDetailView(producto: producto),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

class _ProductDetailView extends ConsumerStatefulWidget {
  final Producto producto;

  const _ProductDetailView({required this.producto});

  @override
  ConsumerState<_ProductDetailView> createState() => __ProductDetailViewState();
}

class __ProductDetailViewState extends ConsumerState<_ProductDetailView> {
  final _quantityController = TextEditingController(text: '1');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(
                producto.imageUrl ?? '',
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100, color: Colors.white70),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stock disponible (${producto.stock} unidades)',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  producto.descripcion,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                if (producto.enOferta)
                  const Text(
                    '¡En Oferta!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Cantidad:',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Ingrese la cantidad',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 50, 50, 50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese una cantidad';
                      }
                      final quantity = int.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'Ingrese un número válido mayor a 0';
                      }
                      if (quantity > producto.stock) {
                        return 'Stock insuficiente (${producto.stock} unidades disponibles)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final quantity = int.parse(_quantityController.text);
                  ref.read(cartProvider.notifier).addItem(producto, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Agregado ${quantity}x ${producto.nombre} al carrito.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Agregar al carrito',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

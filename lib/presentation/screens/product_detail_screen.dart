import 'package:flutter/material.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:accesories_store_flutter/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Para TextInputFormatter
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/presentation/providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  final String categoryId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.categoryId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  ); // Inicia con 1
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  Future<Producto?> _fetchProductById(String productId) async {
    try {
      print('DEBUG: Fetching product: productId=$productId');
      // Búsqueda directa en la colección de productos de nivel superior por su ID
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection(
                'productos',
              ) // Apunta a la colección de nivel superior
              .doc(productId) // Busca directamente por el ID del documento
              .get();

      if (docSnapshot.exists) {
        return Producto.fromMap(
          docSnapshot.id,
          docSnapshot.data() as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: FutureBuilder<Producto?>(
        future: _fetchProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading product: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Product not found.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final producto = snapshot.data!;

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
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.white70,
                          ),
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Stock disponible (${producto.stock} unidades)',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$' + producto.precio.toStringAsFixed(3),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        producto.descripcion,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      if (producto.enOferta)
                        Text(
                          '¡En Oferta!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ), // Espacio antes del campo de cantidad
                      Text(
                        'Cantidad:',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ], // Solo números
                          decoration: InputDecoration(
                            hintText: 'Ingrese la cantidad',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color.fromARGB(255, 50, 50, 50),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 18),
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

                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final quantity = int.parse(_quantityController.text);
                        ref
                            .read(cartProvider.notifier)
                            .addItem(producto, quantity);
                        print(
                          'Agregar al carrito: ${producto.nombre}, Cantidad: $quantity',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Agregado ${quantity}x ${producto.nombre} al carrito.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Agregar al carrito',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),

                SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

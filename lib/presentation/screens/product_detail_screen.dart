import 'package:flutter/material.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:accesories_store_flutter/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  Future<Producto?> _fetchProductById(String productId) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('productos')
              .doc(productId)
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: FutureBuilder<Producto?>(
        future: _fetchProductById(productId),
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
                    ],
                  ),
                ),

                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement add to cart logic - use the 'producto' object
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

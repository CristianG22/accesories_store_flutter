import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'package:accesories_store_flutter/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  @override
  Future<List<Producto>> getSpecialOffers() async {
    try {
      final querySnapshot = await _firestore
          .collection('productos')
          .where('enOferta', isEqualTo: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // En una app real, podrías manejar este error de forma más elegante
      print('Error fetching special offers: $e');
      throw e; // O retornar una lista vacía, dependiendo de tu lógica de manejo de errores
    }
  }

  @override
  Future<Producto> getProductById(String productId) async {
    try {
      final docSnapshot = await _firestore.collection('productos').doc(productId).get();
      if (docSnapshot.exists) {
        return Producto.fromMap(docSnapshot.id, docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      print('Error fetching product by id: $e');
      rethrow;
    }
  }

  @override
  Future<List<Producto>> getProductsByCategory(String categoryId) async {
    try {
      final querySnapshot = await _firestore
          .collection('productos')
          .where('categoriaId', isEqualTo: categoryId)
          .get();
      return querySnapshot.docs
          .map((doc) => Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      rethrow;
    }
  }
} 
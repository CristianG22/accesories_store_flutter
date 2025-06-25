import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accesories_store_flutter/domain/entities/categorie.dart';
import 'package:accesories_store_flutter/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepositoryImpl(this._firestore);

  @override
  Future<String> getCategoryNameById(String categoryId) async {
    try {
      final docSnapshot = await _firestore.collection('categorias').doc(categoryId).get();
      if (docSnapshot.exists) {
       return docSnapshot.data()?['nombre'] ?? 'Nombre no encontrado';
      } else {
        return 'Categoría desconocida';
      }
    } catch (e) {
      print('Error fetching category name: $e');
      rethrow;
    }
  }

  @override
  Future<List<Categorie>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categorias').get();
      return querySnapshot.docs.map((doc) {
        return Categorie.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching all categories: $e');
      rethrow;
    }
  }
} 
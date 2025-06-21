import 'package:accesories_store_flutter/domain/entities/categorie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/data/repositories/category_repository_impl.dart';
import 'package:accesories_store_flutter/domain/repositories/category_repository.dart';

// Provider para la implementación del repositorio de categorías
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(FirebaseFirestore.instance);
});

// Provider para obtener el nombre de una categoría por su ID (Corregido)
final categoryNameProvider = FutureProvider.autoDispose.family<String, String>((ref, categoryId) async {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return categoryRepository.getCategoryNameById(categoryId);
});

// Provider para obtener todas las categorías
final allCategoriesProvider = FutureProvider.autoDispose<List<Categorie>>((ref) {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return categoryRepository.getAllCategories();
}); 
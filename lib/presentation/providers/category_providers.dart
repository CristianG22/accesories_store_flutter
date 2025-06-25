import 'package:accesories_store_flutter/domain/entities/categorie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/data/repositories/category_repository_impl.dart';
import 'package:accesories_store_flutter/domain/repositories/category_repository.dart';


final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(FirebaseFirestore.instance);
});


final categoryNameProvider = FutureProvider.autoDispose.family<String, String>((ref, categoryId) async {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return categoryRepository.getCategoryNameById(categoryId);
});


final allCategoriesProvider = FutureProvider.autoDispose<List<Categorie>>((ref) {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return categoryRepository.getAllCategories();
}); 
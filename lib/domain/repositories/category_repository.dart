import 'package:accesories_store_flutter/domain/entities/categorie.dart';

abstract class CategoryRepository {
  Future<String> getCategoryNameById(String categoryId);
  Future<List<Categorie>> getAllCategories();
} 
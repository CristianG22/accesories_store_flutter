import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'product_repository_provider.dart';

// Provider para obtener los detalles de un solo producto por su ID
final productDetailProvider = FutureProvider.autoDispose.family<Producto, String>((ref, productId) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProductById(productId);
});

// Provider para obtener la lista de productos de una categoría específica
final productsByCategoryProvider = FutureProvider.autoDispose.family<List<Producto>, String>((ref, categoryId) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProductsByCategory(categoryId);
}); 
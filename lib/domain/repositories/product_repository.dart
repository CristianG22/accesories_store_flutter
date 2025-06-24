import 'package:accesories_store_flutter/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Producto>> getSpecialOffers();
  Future<Producto> getProductById(String productId);
  Future<List<Producto>> getProductsByCategory(String categoryId);
} 
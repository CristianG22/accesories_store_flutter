import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accesories_store_flutter/data/repositories/product_repository_impl.dart';
import 'package:accesories_store_flutter/domain/repositories/product_repository.dart';

// Provider para inyectar la dependencia del repositorio
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(FirebaseFirestore.instance);
}); 
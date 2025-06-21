import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'package:accesories_store_flutter/presentation/providers/products_providers.dart';
import 'package:accesories_store_flutter/presentation/providers/category_providers.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';

final _categorySearchTextProvider = StateProvider<String>((ref) => '');
final _categorySelectedFilterProvider = StateProvider<String>((ref) => 'Precio: menor a mayor');

class CategoryProductsScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(_categorySearchTextProvider);
    final selectedFilter = ref.watch(_categorySelectedFilterProvider);
    final productsAsyncValue = ref.watch(productsByCategoryProvider(categoryId));
    final categoryNameAsyncValue = ref.watch(categoryNameProvider(categoryId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          categoryNameAsyncValue.when(
            data: (name) => Text(
              name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            loading: () => const SizedBox(height: 34),
            error: (e, s) => const Text('Error', style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: productsAsyncValue.when(
              data: (productos) {
                // Filtrar y ordenar productos según búsqueda y filtro
                var filtered = productos.where((p) => p.nombre.toLowerCase().contains(searchText.toLowerCase())).toList();
                switch (selectedFilter) {
                  case 'Precio: menor a mayor':
                    filtered.sort((a, b) => a.precio.compareTo(b.precio));
                    break;
                  case 'Precio: mayor a menor':
                    filtered.sort((a, b) => b.precio.compareTo(a.precio));
                    break;
                  case 'Nombre: A-Z':
                    filtered.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
                    break;
                  case 'Nombre: Z-A':
                    filtered.sort((a, b) => b.nombre.toLowerCase().compareTo(a.nombre.toLowerCase()));
                    break;
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay productos en esta categoría.', style: TextStyle(color: Colors.white70)));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final producto = filtered[index];
                    return _CategoryProductItem(producto: producto);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error al cargar productos: $error', style: const TextStyle(color: Colors.red))),
            ),
          ),
          // Búsqueda Rápida al final
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Búsqueda Rápida',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        ref.read(_categorySearchTextProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.cyanAccent,
                        ),
                        filled: true,
                        fillColor: Colors.grey[850],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ordenar por',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedFilter,
                      dropdownColor: Colors.grey[850],
                      iconEnabledColor: Colors.cyanAccent,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                      items: [
                        'Precio: menor a mayor',
                        'Precio: mayor a menor',
                        'Nombre: A-Z',
                        'Nombre: Z-A',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        ref.read(_categorySelectedFilterProvider.notifier).state = value!;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

class _CategoryProductItem extends StatelessWidget {
  final Producto producto;

  const _CategoryProductItem({Key? key, required this.producto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[850],
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.network(
            producto.imageUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, color: Colors.white70),
          ),
        ),
        title: Text(
          producto.nombre,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${producto.precio.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () {
          context.push('/product/${producto.id}');
        },
      ),
    );
  }
}

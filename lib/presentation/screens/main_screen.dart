import 'package:accesories_store_flutter/presentation/providers/category_providers.dart';
import 'package:accesories_store_flutter/presentation/providers/product_repository_provider.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:accesories_store_flutter/domain/entities/product.dart';
import 'package:accesories_store_flutter/domain/entities/categorie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider que obtiene y filtra las ofertas especiales
final specialOffersProvider = FutureProvider.autoDispose<List<Producto>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  List<Producto> products = await productRepository.getSpecialOffers();
  // La lógica de filtrado y ordenamiento fue removida.
  return products;
});

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialOffers = ref.watch(specialOffersProvider);
    final allCategories = ref.watch(allCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'JKtecno',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 74, 74),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Inicio',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // --- Sección de Categorías ---
          allCategories.when(
            data: (categories) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _CategoryIcon(category: categories[index]);
                },
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Ofertas Especiales',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // --- Sección de Ofertas Especiales ---
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              height: 260,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0Xff004B4C), Color(0xFF07CAB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: specialOffers.when(
                data: (products) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCardItem(product: product);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

// Widget para el ícono de categoría
class _CategoryIcon extends StatelessWidget {
  final Categorie category;

  const _CategoryIcon({required this.category});

  IconData _getIconForCategory(String categoryName) {
    final lowerCaseName = categoryName.toLowerCase();
    if (lowerCaseName.contains('auricular')) {
      return Icons.headphones;
    } else if (lowerCaseName.contains('funda')) {
      return Icons.smartphone;
    } else if (lowerCaseName.contains('cargador')) {
      return Icons.electrical_services;
    } else if (lowerCaseName.contains('teclado')) {
      return Icons.keyboard;
    } else if (lowerCaseName.contains('mouse')) {
      return Icons.mouse;
    } else if (lowerCaseName.contains('protector')) {
      return Icons.shield_outlined;
    } else if (lowerCaseName.contains('parlante')) {
      return Icons.speaker;
    }
    return Icons.category; // Icono por defecto
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/categoria/${category.id}');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForCategory(category.nombre),
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.nombre,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Widget para la tarjeta de producto
class _ProductCardItem extends StatelessWidget {
  final Producto product;

  const _ProductCardItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          context.push('/product/${product.id}');
        },
        child: SizedBox(
          width: 160,
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.enOferta)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Oferta!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    product.imageUrl ?? '',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, color: Colors.white70, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.nombre,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '\$${product.precio.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: product.enOferta ? Colors.greenAccent : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

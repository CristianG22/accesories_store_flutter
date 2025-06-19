import 'package:flutter/material.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:accesories_store_flutter/entities/product.dart'; // Assuming you have a Producto entity
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen>
    with SingleTickerProviderStateMixin {
  String _categoryName = 'Cargando...'; // Estado para el nombre de la categoría
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchCategoryName();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoryName() async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('categorias')
              .doc(widget.categoryId)
              .get();
      if (docSnapshot.exists) {
        setState(() {
          _categoryName = docSnapshot.get('nombre') ?? 'Categoría Desconocida';
        });
      } else {
        setState(() {
          _categoryName = 'Categoría No Encontrada';
        });
      }
    } catch (e) {
      setState(() {
        _categoryName = 'Error al cargar categoría';
      });
      print('Error fetching category name: $e');
    }
  }

  // Function to fetch products for a given category
  Future<List<Producto>> _fetchProductsByCategory(String categoryId) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('productos') // Colección de productos de nivel superior
            .where(
              'categoriaId',
              isEqualTo: categoryId,
            ) // Filtrar por campo categoryId
            .get();

    return querySnapshot.docs.map((doc) {
      // Use the fromMap factory from the Producto class
      return Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Producto>> _fetchSpecialOffersByCategory(
    String categoryId,
  ) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('productos')
            .where('categoriaId', isEqualTo: categoryId)
            .where('enOferta', isEqualTo: true) // Filter by special offer
            .get();

    return querySnapshot.docs.map((doc) {
      return Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          const CustomAppBar(), // Or a modified AppBar showing category name
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _categoryName, // Muestra el nombre de la categoría
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Add TabBar for All Products and Special Offers
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Todos los Productos'),
              Tab(text: 'Ofertas Especiales'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: All Products
                FutureBuilder<List<Producto>>(
                  future: _fetchProductsByCategory(widget.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading products: \${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found in this category.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final productos = snapshot.data!;

                    return ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return _CategoryProductItem(producto: producto);
                      },
                    );
                  },
                ),

                // Tab 2: Special Offers
                FutureBuilder<List<Producto>>(
                  future: _fetchSpecialOffersByCategory(widget.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading special offers: \${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No special offers found in this category.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final offers = snapshot.data!;

                    return ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final product = offers[index];
                        return _CategoryProductItem(producto: product);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

// Widget to display a single product item in the category list
class _CategoryProductItem extends StatelessWidget {
  final Producto producto;

  const _CategoryProductItem({Key? key, required this.producto})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[850], // Darker color for list item
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.network(
            producto.imageUrl ?? '', // Handle null or empty imageUrl
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  color: Colors.white70,
                ), // Fallback icon
          ),
        ),
        title: Text(
          producto.nombre,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${producto.precio.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () {
          // *** THIS IS THE NAVIGATION TO THE PRODUCT DETAIL SCREEN ***
          context.push(
            '/product/${producto.id}',
          ); // Navigate to product detail, passing product ID
        },
      ),
    );
  }
}

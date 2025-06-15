import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:accesories_store_flutter/entities/product.dart'; // Importar la entidad Producto
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Asegurar que Riverpod esté importado

class MainScreen extends ConsumerStatefulWidget {
  // Cambiado a ConsumerStatefulWidget
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late Future<List<Producto>> _specialOffersFuture;
  late Future<List<Producto>> _featuredProductsFuture;

  @override
  void initState() {
    super.initState();
    _specialOffersFuture = _fetchSpecialOffers();
    _featuredProductsFuture = _fetchFeaturedProducts();
  }

  Future<List<Producto>> _fetchSpecialOffers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('productos')
              .where('enOferta', isEqualTo: true)
              .get();
      return querySnapshot.docs.map((doc) {
        return Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching special offers: $e');
      return [];
    }
  }

  Future<List<Producto>> _fetchFeaturedProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('productos')
              .get(); // Obtener todos los productos primero

      final nonOfferProducts =
          querySnapshot.docs
              .map((doc) {
                return Producto.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                );
              })
              .where((product) => !product.enOferta)
              .toList(); // Filtrar los que NO están en oferta

      nonOfferProducts.shuffle(); // Mezclar la lista aleatoriamente

      return nonOfferProducts
          .take(2)
          .toList(); // Tomar los dos primeros (aleatorios)
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('MainScreen build method called!'); // Temporary print statement
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
          Center(
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

          Container(
            width: 380,
            height:
                250, // Aumentada la altura para el carrusel de ofertas especiales
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0Xff004B4C),
                  Color(0xFF07CAB3),
                ], // Los colores del degradado
                begin: Alignment.topLeft, // De arriba a la izquierda
                end: Alignment.bottomRight, // Hacia abajo a la derecha
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: FutureBuilder<List<Producto>>(
              future: _specialOffersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay ofertas especiales.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final offers = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final product = offers[index];
                    return _ProductCardItem(
                      product: product,
                    ); // Usar el nuevo widget de tarjeta
                  },
                );
              },
            ),
          ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CircularCategorie(
                categorieIcon: Icons.phone_android,
                categorieName: 'Fundas',
                categorieRoute: '/profile',
              ),

              _CircularCategorie(
                categorieIcon: Icons.headphones,
                categorieName: 'Auriculares',
                categorieRoute: '/profile',
              ),

              _CircularCategorie(
                categorieIcon: Icons.cable,
                categorieName: 'Cargadores',
                categorieRoute: '/profile',
              ),
            ],
          ),

          SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Productos destacados',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height:
                280, // Aumentada la altura para el carrusel de productos destacados
            child: FutureBuilder<List<Producto>>(
              future: _featuredProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay productos destacados.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final products = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCardItem(
                      product: product,
                    ); // Usar el nuevo widget de tarjeta
                  },
                );
              },
            ),
          ),

          SizedBox(height: 20), // Add some padding at the bottom for scrolling
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

class _ProductCardItem extends StatelessWidget {
  final Producto product;

  const _ProductCardItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ), // Margen para separar las tarjetas
      child: InkWell(
        onTap: () {
          context.push(
            '/product/${product.id}',
          ); // Navegar al detalle del producto
        },
        child: SizedBox(
          width: 160,
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    product.imageUrl ?? '', // Usar imageUrl del producto
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 80,
                        ), // Icono de fallback
                  ),
                ),
              ),
              SizedBox(height: 10), // Separación entre la imagen y el título
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis, // Para nombres largos
                ),
              ),
              SizedBox(height: 5), // Separación entre el título y el precio
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '\$${product.precio.toStringAsFixed(2)}', // Mostrar con 2 decimales
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularCategorie extends StatelessWidget {
  final IconData categorieIcon;
  final String categorieName;
  final String categorieRoute;

  const _CircularCategorie({
    super.key,
    required this.categorieIcon,
    required this.categorieName,
    required this.categorieRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100, // Tamaño fijo para el círculo
          height: 100, // Tamaño fijo para el círculo
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 75, 74, 74),
            shape: BoxShape.circle, // Esto hace que sea circular
          ),
          child: Center(
            child: IconButton(
              enableFeedback: false,
              onPressed: () {
                context.push(categorieRoute);
              },
              icon: Icon(categorieIcon, color: Colors.black, size: 50),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          categorieName,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

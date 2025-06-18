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
  String _selectedFilter = 'Precio: menor a mayor';
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _specialOffersFuture = _fetchSpecialOffers();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
        _specialOffersFuture = _fetchSpecialOffers();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Producto>> _fetchSpecialOffers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('productos')
              .where('enOferta', isEqualTo: true)
              .get();
      List<Producto> products =
          querySnapshot.docs.map((doc) {
            return Producto.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();
      // Filtrar por nombre si hay texto de búsqueda
      if (_searchText.isNotEmpty) {
        products =
            products
                .where(
                  (p) => p.nombre.toLowerCase().contains(
                    _searchText.toLowerCase(),
                  ),
                )
                .toList();
      }
      // Ordenar según el filtro seleccionado
      switch (_selectedFilter) {
        case 'Precio: menor a mayor':
          products.sort((a, b) => a.precio.compareTo(b.precio));
          break;
        case 'Precio: mayor a menor':
          products.sort((a, b) => b.precio.compareTo(a.precio));
          break;
        case 'Nombre: A-Z':
          products.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
          );
          break;
        case 'Nombre: Z-A':
          products.sort(
            (a, b) => b.nombre.toLowerCase().compareTo(a.nombre.toLowerCase()),
          );
          break;
      }
      return products;
    } catch (e) {
      print('Error fetching special offers: $e');
      return [];
    }
  }

  void _onFilterChanged(String? newValue) {
    if (newValue != null && newValue != _selectedFilter) {
      setState(() {
        _selectedFilter = newValue;
        _specialOffersFuture = _fetchSpecialOffers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('MainScreen build method called!');
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

          Center(
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

          const SizedBox(height: 24), // Más espacio antes del carrusel

          Center(
            child: Container(
              width:
                  MediaQuery.of(context).size.width *
                  0.98, // Cambiado de 0.86 a 0.98 para que entren dos productos
              height: 260, // Más alto para evitar overflow
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0Xff004B4C), Color(0xFF07CAB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24), // Más compacto
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
                        'Error: [${snapshot.error}',
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
                      return _ProductCardItem(product: product);
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(
            height: 28,
          ), // Menos separación antes de búsqueda rápida
          // Búsqueda Rápida
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                    Text(
                      'Búsqueda Rápida',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20, // Proporcionalmente más chico
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre...',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.cyanAccent,
                        ),
                        filled: true,
                        fillColor: Colors.grey[850],
                        contentPadding: EdgeInsets.symmetric(
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
                    Text(
                      'Ordenar por',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 16, // Proporcionalmente más chico
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedFilter,
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
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                      items:
                          [
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
                      onChanged: _onFilterChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 50,
          ), // Más espacio para que no se superponga con la bottom bar
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
              // Discount badge if on offer
              if (product.enOferta)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green, // Or any color to indicate discount
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
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
                  style: TextStyle(
                    color:
                        product.enOferta ? Colors.greenAccent : Colors.white70,
                    fontSize: 14,
                  ), // Green for offers
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
  final String categoryId;

  const _CircularCategorie({
    super.key,
    required this.categorieIcon,
    required this.categorieName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60, // Smaller size for better fit
          height: 60, // Smaller size for better fit
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 75, 74, 74),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              enableFeedback: false,
              onPressed: () {
                context.push('/categoria/${categoryId}');
              },
              icon: Icon(
                categorieIcon,
                color: Colors.black,
                size: 30,
              ), // Proportional icon size
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          categorieName,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ), // Proportional font size
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

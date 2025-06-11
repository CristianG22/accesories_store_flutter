import 'package:accesories_store_flutter/core/services/firestore_seed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JK Tecno - Principal'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.cyan, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.cyan),
              title: const Text('Ir a Checkout'),
              onTap: () {
                Navigator.pop(context);
                context.push('/checkout');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined, color: Colors.cyan),
              title: const Text('Ir al Carrito'),
              onTap: () {
                Navigator.pop(context);
                context.push('/cart');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.cyan),
              title: const Text('Ir al Perfil'),
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.cyan),
              title: const Text('Ir al login'),
              onTap: () {
                Navigator.pop(context);
                context.push('/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.cyan),
              title: const Text('Ir a categorías'),
              onTap: () {
                Navigator.pop(context);
                context.push('/categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Colors.orange),
              title: const Text('Cargar Categorías (DEV)'),
              onTap: () async {
                Navigator.pop(context);
                await cargarCategoriasConProductos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Categorías cargadas (si no existían).'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.cyan),
              title: const Text('Ver Detalle de Producto'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                context.push('/product/category/3kuhg4HTaHJcdo3gZMin/product/6uoq8Lbrp2w3842QR2c5');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a JK Tecno',
          style: TextStyle(fontSize: 24, color: Colors.cyan),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.home, color: Colors.black),
        onPressed: () {
          context.go('/');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

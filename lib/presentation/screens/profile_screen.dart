import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'JKtecno',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 32,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            Center(
              child: Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Datos personales',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Nombre', style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(
              'Apellido',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text('Email', style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(
              'Nro. teléfono',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 30),
            Text(
              'Historial de compras',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Aquí puedes agregar los pedidos del historial
          ],
        ),
      ),
    );
  }
}

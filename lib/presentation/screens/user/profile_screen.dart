import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNav(),

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
            
          ],
        ),
      ),
    );
  }
}

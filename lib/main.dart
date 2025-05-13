import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Accesorios Store',
      theme: ThemeData(
        useMaterial3: false,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF6D6B6B), // Fondo personalizado
          selectedItemColor: Colors.black, // Color del ítem seleccionado
          unselectedItemColor: Colors.black, // Color de los ítems no seleccionados
          elevation: 0, // Eliminar sombra
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

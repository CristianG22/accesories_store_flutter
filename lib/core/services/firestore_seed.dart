import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> cargarCategoriasConProductos() async {
  final firestore = FirebaseFirestore.instance;

  final categorias = {
    'Fundas': [
      {'nombre': 'Funda Transparente', 'precio': 1500, 'stock': 10},
      {'nombre': 'Funda Antigolpes', 'precio': 2500, 'stock': 5},
    ],
    'Cargadores': [
      {'nombre': 'Cargador Rápido 20W', 'precio': 3500, 'stock': 8},
      {'nombre': 'Cargador Inalámbrico', 'precio': 4200, 'stock': 3},
    ],
    'Auriculares': [
      {'nombre': 'Auriculares In-ear', 'precio': 2000, 'stock': 15},
      {'nombre': 'Auriculares Bluetooth', 'precio': 6000, 'stock': 6},
    ],
  };

  for (final entry in categorias.entries) {
    final categoria = entry.key;
    final productos = entry.value;

    final categoriaRef = firestore.collection('categorias').doc(categoria);

    final categoriaExiste = await categoriaRef.get();
    if (!categoriaExiste.exists) {
      await categoriaRef.set({'nombre': categoria});

      for (final producto in productos) {
        await categoriaRef.collection('productos').add(producto);
      }
    }
  }
}

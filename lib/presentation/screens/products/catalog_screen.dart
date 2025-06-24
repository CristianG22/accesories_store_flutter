import 'package:accesories_store_flutter/domain/entities/categorie.dart';
import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),

      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "Categorias",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(child: _CategoriaList()),
        ],
      ),

      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

class _CategoriaList extends StatelessWidget {
  Future<List<Categorie>> _fetchCategorias() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categorias').get();

    // Crear un Set para rastrear nombres únicos
    final Set<String> nombresUnicos = {};
    final List<Categorie> categoriasUnicas = [];

    for (var doc in querySnapshot.docs) {
      final nombre = doc.get('nombre') ?? 'Sin nombre';
      // Solo agregar si el nombre no ha sido visto antes
      if (nombresUnicos.add(nombre)) {
        categoriasUnicas.add(Categorie(id: doc.id, nombre: nombre));
      }
    }

    return categoriasUnicas;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categorie>>(
      future: _fetchCategorias(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categorias = snapshot.data!;

        if (categorias.isEmpty) {
          return const Center(child: Text('No hay categorías.'));
        }

        return ListView.builder(
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return _CategoriaItem(categoria: categorias[index]);
          },
        );
      },
    );
  }
}

class _CategoriaItem extends StatelessWidget {
  final Categorie categoria;

  const _CategoriaItem({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[900],
      child: ListTile(
        title: Text(
          categoria.nombre,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: const Icon(Icons.category, color: Colors.white),

        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          context.push('/categoria/${categoria.id}');
        },
      ),
    );
  }
}

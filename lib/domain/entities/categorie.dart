class Categorie {
  final String id;
  final String nombre;

  Categorie({
    required this.id,
    required this.nombre,
  });

  factory Categorie.fromMap(String id, Map<String, dynamic> data) {
    return Categorie(
      id: id,
      nombre: data['nombre'] ?? 'Sin nombre',
    );
  }
}
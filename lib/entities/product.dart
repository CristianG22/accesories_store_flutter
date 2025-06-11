class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final bool enOferta;
  final String? imageUrl;
  final String categoryId;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.enOferta,
    this.imageUrl,
    required this.categoryId,
  });

  factory Producto.fromMap(String id, Map<String, dynamic> data) {
    return Producto(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      enOferta: data['enOferta'] ?? false,
      imageUrl: data['imageUrl'] as String?,
      categoryId: data['categoryId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'enOferta': enOferta,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
    };
  }
}

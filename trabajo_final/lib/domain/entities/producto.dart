class Producto {
  final int? id;
  final String nombre;
  final String foto;
  final double precio;
  final String categoria;

  Producto({
    this.id,
    required this.nombre,
    required this.foto,
    required this.precio,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nombre': nombre,
      'foto': foto,
      'precio': precio,
      'categoria': categoria,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
      nombre: map['nombre'] as String? ?? '',
      foto: map['foto'] as String? ?? '',
      precio: (map['precio'] is double)
          ? (map['precio'] as double)
          : double.tryParse(map['precio'].toString()) ?? 0.0,
      categoria: map['categoria'] as String? ?? '',
    );
  }
}

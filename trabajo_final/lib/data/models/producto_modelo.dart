import 'package:trabajo_final/domain/entities/producto.dart';

class ProductoModelo extends Producto {
  ProductoModelo({
    required super.id,
    required super.nombre,
    required super.foto,
    required super.precio,
    required super.categoria,
  });

  factory ProductoModelo.fromJson(Map<String, dynamic> json) {
    return ProductoModelo(
      id: json['id'],
      nombre: json['nombre'],
      foto: json['foto'],
      precio: json['precio'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "foto": foto,
      "precio": precio,
      "categoria": categoria,
    };
  }
}

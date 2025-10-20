import 'package:trabajo_final/domain/entities/producto.dart';

abstract class ProductoEstado {}

class ProductoInicial extends ProductoEstado {}

class ProductoCarga extends ProductoEstado {}

class ProductoCargado extends ProductoEstado {
  final List<Producto> productos;
  ProductoCargado(this.productos);
}

class ProductoError extends ProductoEstado {
  final String msg;
  ProductoError(this.msg);
}

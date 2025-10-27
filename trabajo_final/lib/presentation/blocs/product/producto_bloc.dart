import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_evento.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_estado.dart';
import 'package:trabajo_final/data/database/db.dart';

class ProductoBloc extends Bloc<ProductoEvento, ProductoEstado> {
  ProductoBloc() : super(ProductoInicial()) {
    on<CargarProductos>(_cargarProductos);
    on<FiltrarProductosPorCategoria>(_filtrarPorCategoria);
    on<FiltrarProductosPorNombre>(_buscarProductos);
  }

  // Carga de productos
  Future<void> _cargarProductos(
      CargarProductos event, Emitter<ProductoEstado> emit) async {
    emit(ProductoCarga());
    try {
      final productos = await DB.obtenerProductos();
      emit(ProductoCargado(productos));
    } catch (e) {
      emit(ProductoError('Error al cargar los productos: $e'));
    }
  }

  // Filtro por categoría
  Future<void> _filtrarPorCategoria(
      FiltrarProductosPorCategoria event, Emitter<ProductoEstado> emit) async {
    emit(ProductoCarga());
    try {
      final productos = await DB.obtenerProductos();
      final filtrados = productos
          .where((p) =>
              p.categoria.toLowerCase() == event.categoria.toLowerCase())
          .toList();
      emit(ProductoCargado(filtrados));
    } catch (e) {
      emit(ProductoError('Error al filtrar los productos: $e'));
    }
  }

  // Búsqueda por nombre
  Future<void> _buscarProductos(
      FiltrarProductosPorNombre event, Emitter<ProductoEstado> emit) async {
    emit(ProductoCarga());
    try {
      final productos = await DB.obtenerProductos();

      final query = event.query.trim().toLowerCase();
      if (query.isEmpty) {
        emit(ProductoCargado(productos));
        return;
      }

      final filtrados = productos.where((p) {
        final nombre = p.nombre.toLowerCase();
        final categoria = p.categoria.toLowerCase();
        return nombre.contains(query) || categoria.contains(query);
      }).toList();

      emit(ProductoCargado(filtrados));
    } catch (e) {
      emit(ProductoError('Error al buscar los productos: $e'));
    }
  }
}

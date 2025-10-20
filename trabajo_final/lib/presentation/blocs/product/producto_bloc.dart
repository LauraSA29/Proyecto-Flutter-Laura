import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_evento.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_estado.dart';
import 'package:trabajo_final/data/database/db.dart';

class ProductoBloc extends Bloc<ProductoEvento, ProductoEstado> {
  ProductoBloc() : super(ProductoInicial()) {
    on<CargarProductos>(_cargarProductos);
  }

  Future<void> _cargarProductos(
      CargarProductos event, Emitter<ProductoEstado> emit) async {
    emit(ProductoCarga());

    try {
      final productos = await DB.obtenerProductos();

      emit(ProductoCargado(productos));
    } catch (e) {
      emit(ProductoError('Error al cargar productos: $e'));
    }
  }
}

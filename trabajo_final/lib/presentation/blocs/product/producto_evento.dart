abstract class ProductoEvento {}

class CargarProductos extends ProductoEvento {}
class FiltrarProductosPorCategoria extends ProductoEvento {
  final String categoria;
  FiltrarProductosPorCategoria(this.categoria);
}
class FiltrarProductosPorNombre extends ProductoEvento {
  final String query;
  FiltrarProductosPorNombre(this.query);
}

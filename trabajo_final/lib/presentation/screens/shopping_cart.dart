import 'package:flutter/material.dart';
import 'package:trabajo_final/data/database/db.dart';
import 'package:trabajo_final/presentation/widgets/fondo_decorativo.dart';

class PantallaCarrito extends StatefulWidget {
  const PantallaCarrito({super.key});

// estado de la pantalla del carrito
  @override
  State<PantallaCarrito> createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  List<Map<String, dynamic>> _carrito = [];

  @override
  void initState() {
    super.initState();
    _cargarCarrito();
  }

// cargar los datos del carrito desde la base de datos
  Future<void> _cargarCarrito() async {
    final datos = await DB.obtenerCarrito();
    setState(() {
      _carrito = datos;
    });
  }

  double get _total {
    return _carrito.fold(0.0, (suma, item) {
      return suma + (item['precio'] * item['cantidad']);
    });
  }

// eliminar un producto del carrito
  Future<void> _eliminarProducto(int id) async {
    await DB.eliminarDelCarrito(id);
    await _cargarCarrito();
  }

// vaciar todo el carrito
  Future<void> _vaciarCarrito() async {
    await DB.vaciarCarrito();
    await _cargarCarrito();
  }

// construir la pantalla del carrito
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FondoDecorativo(
        child: _carrito.isEmpty
            ? const Center(
                child: Text(
                  "Tu carrito está vacío",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _carrito.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = _carrito[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item['foto'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['nombre'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${item['precio'].toStringAsFixed(2)} €  x${item['cantidad']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  _eliminarProducto(item['id'] as int),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomBar(context),
                ],
              ),
      ),
    );
  }

  // appbar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      title: const Text(
        "¡TU CARRITO!",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B6CF6), Color(0xFFE96FFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  // barra inferior con total y botones
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${_total.toStringAsFixed(2)} €",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _vaciarCarrito,
                child: const Text("Vaciar carrito"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B6CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () { //compra simulada
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Compra finalizada con éxito"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  _vaciarCarrito();
                },
                child: const Text("Finalizar compra"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

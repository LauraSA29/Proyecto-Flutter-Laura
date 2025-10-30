import 'package:flutter/material.dart';
import 'package:trabajo_final/domain/entities/producto.dart';
import 'package:trabajo_final/data/database/db.dart';
import 'package:trabajo_final/presentation/widgets/fondo_decorativo.dart';

class PantallaDetalleProducto extends StatefulWidget {
  final Producto producto;

  const PantallaDetalleProducto({super.key, required this.producto});

  @override
  State<PantallaDetalleProducto> createState() =>
      _PantallaDetalleProductoState();
}

// estado de la pantalla de detalle del producto
class _PantallaDetalleProductoState extends State<PantallaDetalleProducto> {
  int cantidad = 1;
  int tallaSeleccionada = 40;
  Color colorSeleccionado = Colors.blue;

  final List<int> tallas = [40, 41, 42];
  final List<Color> colores = [Colors.red, Colors.green, Colors.blue];

// construcción de la screen
  @override
  Widget build(BuildContext context) {
    final double topSpacing = kToolbarHeight + 20;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: FondoDecorativo(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, topSpacing, 20, 30),
          child: Column(
            children: [
              _buildImagenProducto(),
              const SizedBox(height: 28),
              _buildCardDetalles(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

// appbar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 65,
      title: Text(
        widget.producto.nombre.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B6CF6), Color(0xFFE96FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

// imagen del producto
  Widget _buildImagenProducto() {
    return Hero(
      tag: '${widget.producto.id ?? widget.producto.nombre}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            widget.producto.foto,
            fit: BoxFit.cover,
            height: 270,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 270,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported,
                    size: 72, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }

// tarjeta de detalles del producto
  Widget _buildCardDetalles(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          Text(
            widget.producto.nombre,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.producto.precio.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF43A047),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

        //secciones de cantidad, talla y color

          _seccionTitulo('Cantidad'),
          const SizedBox(height: 8),
          _buildCantidadSlider(),
          const SizedBox(height: 16),

          _seccionTitulo('Talla'),
          const SizedBox(height: 10),
          _buildSelectorTalla(),

          const SizedBox(height: 18),

          _seccionTitulo('Color'),
          const SizedBox(height: 10),
          _buildSelectorColor(),

          const SizedBox(height: 24),
          _buildBotonAgregar(context),
        ],
      ),
    );
  }

// sección de título
  Widget _seccionTitulo(String texto) => Text(
        texto,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5C4DDC),
        ),
      );

// slider de cantidad
  Widget _buildCantidadSlider() {
    return Column(
      children: [
        Slider(
          value: cantidad.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: '$cantidad',
          activeColor: const Color(0xFF7B6CF6),
          onChanged: (value) => setState(() => cantidad = value.toInt()),
        ),
        Text(
          'Cantidad: $cantidad',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }

// selector de talla
  Widget _buildSelectorTalla() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tallas.map((talla) {
        final seleccionada = talla == tallaSeleccionada;
        return GestureDetector(
          onTap: () => setState(() => tallaSeleccionada = talla),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color:
                  seleccionada ? const Color(0xFF7B6CF6) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: seleccionada
                    ? const Color(0xFF7B6CF6)
                    : Colors.grey.shade400,
                width: 1.5,
              ),
              boxShadow: seleccionada
                  ? [
                      BoxShadow(
                          color:
                              const Color(0xFF7B6CF6).withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Text(
              talla.toString(),
              style: TextStyle(
                color: seleccionada ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

// selector de color
  Widget _buildSelectorColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colores.map((color) {
        final seleccionada = color == colorSeleccionado;
        return GestureDetector(
          onTap: () => setState(() => colorSeleccionado = color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: seleccionada
                    ? Colors.black
                    : Colors.grey.shade300,
                width: seleccionada ? 2 : 1,
              ),
              boxShadow: seleccionada
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.45),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
          ),
        );
      }).toList(),
    );
  }

// botón de agregar al carrito
  Widget _buildBotonAgregar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B6CF6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 6,
              shadowColor: const Color(0xFF7B6CF6).withOpacity(0.35),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text(
              'AÑADIR AL CARRITO',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              for (int i = 0; i < cantidad; i++) {
                await DB.insertarEnCarrito(widget.producto);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${widget.producto.nombre} añadido al carrito 🛍️'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

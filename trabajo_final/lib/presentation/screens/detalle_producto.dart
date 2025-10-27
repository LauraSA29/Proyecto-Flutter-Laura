import 'package:flutter/material.dart';
import 'package:trabajo_final/domain/entities/producto.dart';
import 'package:trabajo_final/data/database/db.dart';

class PantallaDetalleProducto extends StatefulWidget {
  final Producto producto;

  const PantallaDetalleProducto({super.key, required this.producto});

  @override
  State<PantallaDetalleProducto> createState() =>
      _PantallaDetalleProductoState();
}

class _PantallaDetalleProductoState extends State<PantallaDetalleProducto> {
  int cantidad = 1;
  int tallaSeleccionada = 40;
  Color colorSeleccionado = Colors.blue;

  final List<int> tallas = [40, 41, 42];
  final List<Color> colores = [Colors.red, Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context) {
    // Altura que dejamos para que el contenido no quede bajo la AppBar transparente
    final double topSpacing = kToolbarHeight + 20;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      ),

      // Usamos Stack para poner primero el fondo (gradiente + figuras) y encima el contenido
      body: Stack(
        children: [
          // Degradado general de fondo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5EFFF), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Figuras decorativas (círculos/rect)
          Positioned(
            top: -60,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFBBA8FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -70,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFF3B7FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: 40,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: Color(0xFFD5C4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            right: 30,
            child: Transform.rotate(
              angle: 0.4,
              child: Opacity(
                opacity: 0.45,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3B7FF).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // Contenido principal (por encima del fondo)
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, topSpacing, 20, 30),
            child: Column(
              children: [
                // Imagen con marco suave + Hero
                Hero(
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
                          // placeholder si falta la imagen
                          return Container(
                            height: 270,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported, size: 72, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Tarjeta de información principal
                Container(
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

                      // Cantidad
                      _seccionTitulo('Cantidad'),
                      const SizedBox(height: 8),
                      Slider(
                        value: cantidad.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '$cantidad',
                        activeColor: const Color(0xFF7B6CF6),
                        onChanged: (value) => setState(() => cantidad = value.toInt()),
                      ),
                      Text('Cantidad: $cantidad', style: const TextStyle(fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 16),

                      // Tallas
                      _seccionTitulo('Talla'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: tallas.map((talla) {
                          final seleccionada = talla == tallaSeleccionada;
                          return GestureDetector(
                            onTap: () => setState(() => tallaSeleccionada = talla),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: seleccionada ? const Color(0xFF7B6CF6) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: seleccionada ? const Color(0xFF7B6CF6) : Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                boxShadow: seleccionada
                                    ? [BoxShadow(color: const Color(0xFF7B6CF6).withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
                                    : [],
                              ),
                              child: Text(
                                talla.toString(),
                                style: TextStyle(color: seleccionada ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Colores
                      _seccionTitulo('Color'),
                      const SizedBox(height: 10),
                      Row(
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
                                border: Border.all(color: seleccionada ? Colors.black : Colors.grey.shade300, width: seleccionada ? 2 : 1),
                                boxShadow: seleccionada ? [BoxShadow(color: color.withOpacity(0.45), blurRadius: 10, spreadRadius: 2)] : [],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Botón añadir
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B6CF6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 6,
                                shadowColor: const Color(0xFF7B6CF6).withOpacity(0.35),
                              ),
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('AÑADIR AL CARRITO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                for (int i = 0; i < cantidad; i++) {
                                  await DB.insertarEnCarrito(widget.producto);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${widget.producto.nombre} añadido al carrito 🛍️'), duration: const Duration(seconds: 2)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionTitulo(String texto) => Text(
        texto,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5C4DDC),
        ),
      );
}

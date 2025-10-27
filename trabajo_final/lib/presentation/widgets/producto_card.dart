import 'package:flutter/material.dart';
import 'package:trabajo_final/domain/entities/producto.dart';
import 'package:trabajo_final/presentation/screens/detalle_producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

 // carta de producto para añadir al carrito
  const ProductoCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_crearRutaDetalle(producto));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Hero(
                  tag: producto.foto, // animación entre pantallas
                  child: Image.asset(
                    producto.foto,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Nombre del producto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                producto.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Precio del producto 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${producto.precio.toStringAsFixed(2)} €",
                style: const TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Ruta personalizada con animación
  Route _crearRutaDetalle(Producto producto) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) =>
          PantallaDetalleProducto(producto: producto),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeIn),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }
}

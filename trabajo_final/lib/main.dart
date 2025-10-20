import 'package:flutter/foundation.dart' show kIsWeb; // 👈 Importante
import 'package:flutter/material.dart';
import 'package:trabajo_final/presentation/screens/home_screen.dart';
import 'package:trabajo_final/data/database/db.dart';
import 'package:trabajo_final/domain/entities/producto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  if (!kIsWeb) {
    final db = await DB.database;

    final productos = await DB.obtenerProductos();

    if (productos.isEmpty) {
      await DB.insertarProducto(
        Producto(
          id: 1,
          nombre: 'Camisa Blanca',
          precio: 19.99,
          foto: 'assets/img/camisaBlanca.png',
          categoria: 'Camisas',
        ),
      );
      await DB.insertarProducto(
        Producto(
          id: 2,
          nombre: 'Pantalón Negro',
          precio: 29.99,
          foto: 'assets/img/pantalonNegro.png',
          categoria: 'Pantalones',
        ),
      );
      await DB.insertarProducto(
        Producto(
          id: 3,
          nombre: 'Zapatillas Clásicas',
          precio: 49.99,
          foto: 'assets/img/zapatillas.png',
          categoria: 'Zapatos',
        ),
      );
      await DB.insertarProducto(
        Producto(
          id: 4,
          nombre: 'Bolso Marrón',
          precio: 39.99,
          foto: 'assets/img/bolso.png',
          categoria: 'Bolsos',
        ),
      );
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda de Ropa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7B6CF6),
        fontFamily: 'Roboto',
      ),
      home: const PantallaInicio(),
    );
  }
}

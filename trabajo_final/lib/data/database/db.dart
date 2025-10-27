import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:trabajo_final/domain/entities/producto.dart';

class DB {
  static Database? _database;

  // Obtiene o inicializa la base de datos
  static Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  // Inicializa la base de datos dependiendo de la plataforma
  static Future<Database> _initDB() async {
    if (kIsWeb) throw Exception('SQLite no funciona en Web');

    // SQLite para escritorio
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'productos.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _crearTablas,
      onUpgrade: _actualizarTablas,
    );
  }

  // Crea las tablas iniciales
  static Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos(
        id TEXT PRIMARY KEY,
        nombre TEXT,
        precio REAL,
        foto TEXT,
        categoria TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE carrito(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        producto_id TEXT,
        nombre TEXT,
        precio REAL,
        foto TEXT,
        cantidad INTEGER
      )
    ''');
  }

  /// Actualiza la estructura de tablas
  static Future<void> _actualizarTablas(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE carrito(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          producto_id TEXT,
          nombre TEXT,
          precio REAL,
          foto TEXT,
          cantidad INTEGER
        )
      ''');
    }
  }

  // Metodos para productos
  static Future<void> insertarProducto(Producto producto) async {
    final db = await database;
    await db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Producto>> obtenerProductos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productos');
    return maps.map((map) => Producto.fromMap(map)).toList();
  }

  static Future<void> borrarProductos() async {
    final db = await database;
    await db.delete('productos');
  }

  // Metodos para carrito
  static Future<void> insertarEnCarrito(Producto producto) async {
    final db = await database;

    final existe = await db.query(
      'carrito',
      where: 'producto_id = ?',
      whereArgs: [producto.id],
    );

    if (existe.isNotEmpty) {
      final cantidadActual = existe.first['cantidad'] as int;
      await db.update(
        'carrito',
        {'cantidad': cantidadActual + 1},
        where: 'producto_id = ?',
        whereArgs: [producto.id],
      );
    } else {
      await db.insert('carrito', {
        'producto_id': producto.id,
        'nombre': producto.nombre,
        'precio': producto.precio,
        'foto': producto.foto,
        'cantidad': 1,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerCarrito() async {
    final db = await database;
    return db.query('carrito');
  }

  static Future<void> eliminarDelCarrito(int id) async {
    final db = await database;
    await db.delete('carrito', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> vaciarCarrito() async {
    final db = await database;
    await db.delete('carrito');
  }

  // inseetar datos
  static Future<void> initDataIfEmpty() async {
    final productos = await obtenerProductos();
    if (productos.isNotEmpty) return;

    final listaProductos = _productosIniciales();

    for (final producto in listaProductos) {
      await insertarProducto(producto);
    }
  }

  // Lista de productos

  static List<Producto> _productosIniciales() => [
        // Camisas
        Producto(id: 1, nombre: 'Camisa Blanca', precio: 19.99, foto: 'assets/img/camisaBlanca.png', categoria: 'Camisas'),
        Producto(id: 2, nombre: 'Camisa Azul', precio: 24.99, foto: 'assets/img/camisaAzul.png', categoria: 'Camisas'),
        Producto(id: 3, nombre: 'Camisa de Cuadros', precio: 22.99, foto: 'assets/img/camisaCuadros.png', categoria: 'Camisas'),
        Producto(id: 4, nombre: 'Camisa Negra', precio: 21.99, foto: 'assets/img/camisaNegra.png', categoria: 'Camisas'),

        // Pantalones
        Producto(id: 5, nombre: 'Pantalón Negro', precio: 29.99, foto: 'assets/img/pantalonNegro.png', categoria: 'Pantalones'),
        Producto(id: 6, nombre: 'Pantalón Vaquero', precio: 34.99, foto: 'assets/img/pantalonVaquero.png', categoria: 'Pantalones'),
        Producto(id: 7, nombre: 'Pantalón Beige', precio: 32.50, foto: 'assets/img/pantalonBeige.png', categoria: 'Pantalones'),
        Producto(id: 8, nombre: 'Pantalón Gris', precio: 27.99, foto: 'assets/img/pantalonGris.png', categoria: 'Pantalones'),

        // Zapatos
        Producto(id: 9, nombre: 'Zapatillas Clásicas', precio: 49.99, foto: 'assets/img/zapatillas.png', categoria: 'Zapatos'),
        Producto(id: 10, nombre: 'Zapatos Negros', precio: 59.99, foto: 'assets/img/zapatosNegros.png', categoria: 'Zapatos'),
        Producto(id: 11, nombre: 'Botas Marrones', precio: 64.99, foto: 'assets/img/botasMarrones.png', categoria: 'Zapatos'),
        Producto(id: 12, nombre: 'Sandalias Verano', precio: 29.99, foto: 'assets/img/sandalias.png', categoria: 'Zapatos'),

        // Bolsos
        Producto(id: 13, nombre: 'Bolso Marrón', precio: 39.99, foto: 'assets/img/bolso.png', categoria: 'Bolsos'),
        Producto(id: 14, nombre: 'Bolso Negro', precio: 44.99, foto: 'assets/img/bolsoNegro.png', categoria: 'Bolsos'),
        Producto(id: 15, nombre: 'Mochila Casual', precio: 35.99, foto: 'assets/img/mochila.png', categoria: 'Bolsos'),
        Producto(id: 16, nombre: 'Bolso Rojo', precio: 42.99, foto: 'assets/img/bolsoRojo.png', categoria: 'Bolsos'),

        // Sombreros
        Producto(id: 17, nombre: 'Sombrero Fedora', precio: 25.99, foto: 'assets/img/sombreroFedora.png', categoria: 'Sombreros'),
        Producto(id: 18, nombre: 'Gorra Negra', precio: 15.99, foto: 'assets/img/gorraNegra.png', categoria: 'Sombreros'),
        Producto(id: 19, nombre: 'Sombrero de Paja', precio: 18.99, foto: 'assets/img/sombreroPaja.png', categoria: 'Sombreros'),
        Producto(id: 20, nombre: 'Gorra Blanca', precio: 14.99, foto: 'assets/img/gorraBlanca.png', categoria: 'Sombreros'),

        // Accesorios
        Producto(id: 21, nombre: 'Reloj Clásico', precio: 79.99, foto: 'assets/img/relojClasico.png', categoria: 'Accesorios'),
        Producto(id: 22, nombre: 'Pulsera de Cuero', precio: 19.99, foto: 'assets/img/pulseraCuero.png', categoria: 'Accesorios'),
        Producto(id: 23, nombre: 'Collar Plateado', precio: 29.99, foto: 'assets/img/collarPlateado.png', categoria: 'Accesorios'),
        Producto(id: 24, nombre: 'Gafas de Sol', precio: 24.99, foto: 'assets/img/gafasSol.png', categoria: 'Accesorios'),
      ];
}

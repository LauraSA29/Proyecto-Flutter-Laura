import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:trabajo_final/domain/entities/producto.dart';

class DB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    if (kIsWeb) {
      throw Exception('SQLite no está soportado en Web.');
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'productos.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _crearTablas,
      onUpgrade: (db, oldVersion, newVersion) async {
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
      },
    );
  }

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
    return List.generate(
      maps.length,
      (i) => Producto.fromMap(maps[i]),
    );
  }

  static Future<void> borrarProductos() async {
    final db = await database;
    await db.delete('productos');
  }

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
    return await db.query('carrito');
  }

  static Future<void> eliminarDelCarrito(int id) async {
    final db = await database;
    await db.delete('carrito', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> vaciarCarrito() async {
    final db = await database;
    await db.delete('carrito');
  }
}

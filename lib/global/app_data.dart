import 'dart:convert';
import 'package:keepit/models/categoria.dart';
import 'package:keepit/models/objeto.dart';
import 'package:keepit/services/storage_service.dart';

class AppData {
  AppData._privateConstructor();
  static final AppData instance = AppData._privateConstructor();

  final StorageService storage = StorageService();

  // -------------------- OBJETOS --------------------
  List<Objeto> objects = [];

  Future<void> loadObjects() async {
    objects = await storage.readObjetos();
  }

  Future<void> saveObjects() async {
    await storage.writeObjetos(objects);
  }

  void addObject(Objeto obj) {
    objects.add(obj);
    saveObjects();
  }

  void removeObject(Objeto obj) {
    objects.remove(obj);
    saveObjects();
  }

  void clearObjects() {
    objects.clear();
    saveObjects();
  }

  // -------------------- CATEGORÍAS --------------------
  List<Categoria> categorias = [];
  final List<Categoria> _defaultCategorias = [
    Categoria(nombre: 'Electrónica', colorHex: '#FF5733'),
    Categoria(nombre: 'Ropa', colorHex: '#E980FF'),
    Categoria(nombre: 'Libros', colorHex: '#3357FF'),
  ];

  Future<void> loadCategorias() async {
    //clearCategorias();
    final loaded = await storage.readCategorias();
    if (loaded.isEmpty) {
      categorias = List.from(_defaultCategorias);
      await saveCategorias();
    } else {
      categorias = loaded;
    }
  }

  Future<void> saveCategorias() async {
    printCategoriasJson();
    await storage.writeCategorias(categorias);
  }

  void agregarCategoria(String nombre, String colorHex) {
    if (!categorias.any((cat) => cat.nombre == nombre)) {
      categorias.add(Categoria(nombre: nombre, colorHex: colorHex));
      saveCategorias();
    }
  }

  /// Devuelve true si se eliminó, false si no (porque está en uso)
  bool eliminarCategoria(Categoria cat) {
    // Verificar si algún objeto usa esta categoría
    final estaEnUso = objects.any((obj) => obj.categoria.nombre == cat.nombre);

    if (estaEnUso) {
      return false; // No se puede eliminar
    }

    // Si no está en uso, eliminarla
    categorias.remove(cat);
    saveCategorias();
    return true;
  }

  void clearCategorias() {
    categorias.clear();
    saveCategorias();
  }

  // -------------------- UBICACIONES --------------------
  List<String> ubicaciones = [];
  final List<String> _defaultUbicaciones = ['Dentro de casa', 'Fuera de casa'];

  Future<void> loadUbicaciones() async {
    final loaded = await storage.readUbicaciones();
    if (loaded.isEmpty) {
      ubicaciones = List.from(_defaultUbicaciones);
      await saveUbicaciones();
    } else {
      ubicaciones = loaded;
    }
  }

  Future<void> saveUbicaciones() async {
    await storage.writeUbicaciones(ubicaciones);
  }

  void agregarUbicacion(String ubicacion) {
    if (!ubicaciones.contains(ubicacion)) {
      ubicaciones.add(ubicacion);
      saveUbicaciones();
    }
  }

  /// Devuelve true si se eliminó, false si no (porque algún objeto la está usando)
  bool eliminarUbicacion(String ubicacion) {
    // Verificar si algún objeto está en esta ubicación
    final estaEnUso = objects.any((obj) => obj.ubicacion == ubicacion);

    if (estaEnUso) {
      return false; // No se puede eliminar
    }

    // Si no está en uso, eliminarla
    ubicaciones.remove(ubicacion);
    saveUbicaciones();
    return true;
  }

  void clearUbicaciones() {
    ubicaciones.clear();
    saveUbicaciones();
  }

  // -------------------- DEBUG / UTILIDADES --------------------
  void printCategoriasJson() {
    final jsonStr = jsonEncode(categorias.map((e) => e.toJson()).toList());
    print('Categorías JSON: $jsonStr');
  }

  void printUbicacionesJson() {
    final jsonStr = jsonEncode(ubicaciones);
    print('Ubicaciones JSON: $jsonStr');
  }
}

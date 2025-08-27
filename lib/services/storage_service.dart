import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/objeto.dart';
import '../models/categoria.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _objetosFile async {
    final path = await _localPath;
    return File('$path/objetos.json');
  }

  Future<File> get _categoriasFile async {
    final path = await _localPath;
    return File('$path/categorias.json');
  }

  Future<File> get _ubicacionesFile async {
    final path = await _localPath;
    return File('$path/ubicaciones.json');
  }

  // OBJETOS
  Future<List<Objeto>> readObjetos() async {
    try {
      final file = await _objetosFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();

      print('Contenido del archivo objetos.json: $contents'); // <-- AÑADE ESTO

      List jsonData = json.decode(contents);
      return jsonData.map((e) => Objeto.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeObjetos(List<Objeto> objetos) async {
    final file = await _objetosFile;
    final jsonString = json.encode(objetos.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  // CATEGORÍAS
  Future<List<Categoria>> readCategorias() async {
    try {
      final file = await _categoriasFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      List jsonData = json.decode(contents);
      return jsonData.map((e) => Categoria.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeCategorias(List<Categoria> categorias) async {
    final file = await _categoriasFile;
    final jsonString = json.encode(categorias.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  // UBICACIONES
  Future<List<String>> readUbicaciones() async {
    try {
      final file = await _ubicacionesFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      List jsonData = json.decode(contents);
      return List<String>.from(jsonData);
    } catch (_) {
      return [];
    }
  }

  Future<void> writeUbicaciones(List<String> ubicaciones) async {
    final file = await _ubicacionesFile;
    final jsonString = json.encode(ubicaciones);
    await file.writeAsString(jsonString);
  }
}

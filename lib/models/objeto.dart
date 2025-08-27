import 'package:keepit/models/categoria.dart';

class Objeto {
  String nombre;
  Categoria categoria;
  String ubicacion;
  String description;
  String fecha;

  Objeto({
    required this.nombre,
    required this.categoria,
    required this.ubicacion,
    required this.description,
    required this.fecha,
  });

  factory Objeto.fromJson(Map<String, dynamic> json) {
    return Objeto(
      nombre: json['nombre'],
      categoria: Categoria.fromJson(json['categoria']), 
      ubicacion: json['ubicacion'],
      description: json['description'] ?? '',
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'categoria': categoria.toJson(), 
    'ubicacion': ubicacion,
    'description': description,
    'fecha': fecha,
  };
}

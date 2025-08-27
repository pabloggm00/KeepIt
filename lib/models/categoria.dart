class Categoria {
  String nombre;
  String colorHex; 

  Categoria({
    required this.nombre,
    required this.colorHex,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      nombre: json['nombre'],
      colorHex: json['colorHex'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'colorHex': colorHex,
      };
}

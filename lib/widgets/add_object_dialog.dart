import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/models/categoria.dart';
import 'package:keepit/models/objeto.dart';

class AddObjectDialog extends StatefulWidget {
  final Function(Objeto) onAdd;

  const AddObjectDialog({super.key, required this.onAdd});

  @override
  State<AddObjectDialog> createState() => _AddObjectDialogState();
}

class _AddObjectDialogState extends State<AddObjectDialog> {
  String newName = '';
  Categoria? selectedCategoria;
  String? selectedUbicacion;
  String? newDescription;

  List<Categoria> categorias = [];
  List<String> ubicaciones = [];

  @override
  void initState() {
    super.initState();
    _loadCategoriasYUbicaciones();
  }

  Future<void> _loadCategoriasYUbicaciones() async {
    await AppData.instance.loadCategorias();
    await AppData.instance.loadUbicaciones();
    setState(() {
      categorias = List.from(AppData.instance.categorias);
      ubicaciones = List.from(AppData.instance.ubicaciones);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text('Agregar Objeto', style: AppTextStyles.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: AppTextStyles.hintText,
              ),
              style: AppTextStyles.inputText,
              onChanged: (value) => setState(() => newName = value),
            ),
            const SizedBox(height: 10),
            DropdownButton<Categoria>(
              menuWidth: 250,
              dropdownColor: AppColors.surface,
              hint: const Text(
                'Selecciona categoría',
                style: AppTextStyles.hintText,
              ),
              value: selectedCategoria,
              isExpanded: true,
              items: categorias.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  alignment: Alignment.center,
                  child: Text(cat.nombre, style: AppTextStyles.dropdownText),
                );
              }).toList(),
              onChanged: (cat) => setState(() => selectedCategoria = cat),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              menuWidth: 250,
              dropdownColor: AppColors.surface,
              hint: const Text(
                'Selecciona ubicación',
                style: AppTextStyles.hintText,
              ),
              value: selectedUbicacion,
              isExpanded: true,
              items: ubicaciones.map((ubic) {
                return DropdownMenuItem(
                  value: ubic,
                  alignment: Alignment.center,
                  child: Text(ubic, style: AppTextStyles.dropdownText),
                );
              }).toList(),
              onChanged: (ubic) => setState(() => selectedUbicacion = ubic),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
                labelStyle: AppTextStyles.hintText,
              ),
              style: AppTextStyles.inputText,
              onChanged: (value) => setState(() {
                newDescription = value;
              }),
              maxLines: 4,
              minLines: 2,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: AppTextStyles.button),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.acceptButton,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (newName.isNotEmpty &&
                selectedCategoria != null &&
                selectedUbicacion != null) {
              Objeto nuevo = Objeto(
                nombre: newName,
                categoria: selectedCategoria!, // Guarda solo el nombre
                ubicacion: selectedUbicacion!,
                description: newDescription ?? '',
                fecha: DateTime.now().toIso8601String(),
              );
              widget.onAdd(nuevo);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Objeto agregado correctamente')),
              );
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}

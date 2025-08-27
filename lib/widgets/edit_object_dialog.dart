import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/models/categoria.dart';
import 'package:keepit/models/objeto.dart';

class EditObjectDialog extends StatefulWidget {
  final Objeto objeto;
  final Function(Objeto) onEdit;

  const EditObjectDialog({
    super.key,
    required this.objeto,
    required this.onEdit,
  });

  @override
  State<EditObjectDialog> createState() => _EditObjectDialogState();
}

class _EditObjectDialogState extends State<EditObjectDialog> {
  List<Categoria> categorias = [];
  List<String> ubicaciones = [];

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  Categoria? selectedCategoria;
  String? selectedUbicacion;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores
    nameController = TextEditingController(text: widget.objeto.nombre);
    descriptionController = TextEditingController(
      text: widget.objeto.description,
    );

    _loadCategoriasYUbicaciones();
  }

  Future<void> _loadCategoriasYUbicaciones() async {
    await AppData.instance.loadCategorias();
    await AppData.instance.loadUbicaciones();
    setState(() {
      categorias = List.from(AppData.instance.categorias);
      ubicaciones = List.from(AppData.instance.ubicaciones);
    });

    // Selección inicial
    selectedCategoria = categorias.isNotEmpty
        ? categorias.firstWhere(
            (cat) => cat.nombre == widget.objeto.categoria.nombre,
            orElse: () => categorias[0],
          )
        : null;

    selectedUbicacion = ubicaciones.contains(widget.objeto.ubicacion)
        ? widget.objeto.ubicacion
        : (ubicaciones.isNotEmpty ? ubicaciones[0] : null);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool _isValid() {
    return nameController.text.trim().isNotEmpty &&
        selectedCategoria != null &&
        selectedUbicacion != null;
  }

  void _guardarCambios() {
    if (_isValid()) {
      final actualizado = Objeto(
        nombre: nameController.text.trim(),
        categoria: selectedCategoria!,
        ubicacion: selectedUbicacion!,
        description: descriptionController.text.trim(),
        fecha: widget.objeto.fecha,
      );

      widget.onEdit(actualizado);

      // Mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Objeto "${actualizado.nombre}" actualizado correctamente',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes completar todos los campos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text('Editar ${widget.objeto.nombre}', style: AppTextStyles.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre', labelStyle: AppTextStyles.caption, border: OutlineInputBorder()),
              controller: nameController,
              style: AppTextStyles.inputText,
            ),
            const SizedBox(height: 10),
            DropdownButton<Categoria>(
              hint: const Text('Selecciona categoría', style: AppTextStyles.inputText),
              value: selectedCategoria,
              isExpanded: true,
              items: categorias
                  .map(
                    (cat) =>
                        DropdownMenuItem(value: cat, alignment: Alignment.center, child: Text(cat.nombre, style: AppTextStyles.inputText)),
                  )
                  .toList(),
              onChanged: (cat) => setState(() => selectedCategoria = cat),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text('Selecciona ubicación'),
              value: selectedUbicacion,
              isExpanded: true,
              items: ubicaciones
                  .map(
                    (ubic) => DropdownMenuItem(value: ubic, alignment: Alignment.center, child: Text(ubic, style: AppTextStyles.inputText)),
                  )
                  .toList(),
              onChanged: (ubic) => setState(() => selectedUbicacion = ubic),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                labelStyle: AppTextStyles.caption,
                border: OutlineInputBorder(),
              ),
              style: AppTextStyles.inputText,
              controller: descriptionController,
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
          onPressed: _guardarCambios,
          child: const Text('Guardar cambios'),
        ),
      ],
    );
  }
}

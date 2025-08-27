import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';

class AddUbicacionDialog extends StatefulWidget {
  const AddUbicacionDialog({super.key});

  @override
  State<AddUbicacionDialog> createState() => _AddUbicacionDialogState();
}

class _AddUbicacionDialogState extends State<AddUbicacionDialog> {
  String newUbicacion = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text('Agregar ubicación', style: AppTextStyles.title),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'Nombre de la ubicación',
          labelStyle: AppTextStyles.hintText,
        ),
        style: AppTextStyles.inputText,
        onChanged: (value) => newUbicacion = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: AppTextStyles.button),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.acceptButton,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final trimmed = newUbicacion.trim();
            if (trimmed.isNotEmpty) {
              AppData.instance.agregarUbicacion(trimmed);
              Navigator.pop(context, true);
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}

// Nuevo widget para el diálogo de agregar categoría
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  String newCategoryName = '';
  Color pickedColor = const Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text('Agregar categoría', style: AppTextStyles.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Nombre de la categoría',
              labelStyle: AppTextStyles.hintText,
            ),
            style: AppTextStyles.inputText,
            onChanged: (value) => newCategoryName = value,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Color:', style: AppTextStyles.subtitle),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.pickerColor,
                      title: const Text('Selecciona un color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickedColor,
                          onColorChanged: (color) {
                            setState(() {
                              pickedColor = color;
                            });
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: pickedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            if (newCategoryName.trim().isNotEmpty) {
              final colorHex =
                  '#${pickedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
              AppData.instance.agregarCategoria(
                newCategoryName.trim(),
                colorHex,
              );
              Navigator.pop(context, true);
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}

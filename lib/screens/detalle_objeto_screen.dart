import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/widgets/edit_object_dialog.dart';
import 'package:keepit/widgets/gradient_button.dart';
import '../models/objeto.dart';

class DetalleObjetoScreen extends StatefulWidget {
  final Objeto objeto;

  const DetalleObjetoScreen({super.key, required this.objeto});

  @override
  State<DetalleObjetoScreen> createState() => _DetalleObjetoScreenState();
}

class _DetalleObjetoScreenState extends State<DetalleObjetoScreen> {
  late Objeto objeto; // Variable mutable para actualizar la UI

  @override
  void initState() {
    super.initState();
    objeto = widget.objeto; // Inicializamos con el objeto pasado
  }

  String formatearFecha(String fechaIso) {
    final fecha = DateTime.parse(fechaIso);
    return DateFormat('dd/MM/yyyy – HH:mm').format(fecha);
  }

  Widget _seccion({
    required IconData icono,
    required String titulo,
    required String contenido,
    bool expandirTexto = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: expandirTexto
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(
            icono,
            size: 28,
            color: Color(
              int.parse(objeto.categoria.colorHex.replaceFirst('#', '0xff')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contenido,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: expandirTexto ? TextAlign.justify : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(objeto.nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: Color(
          int.parse(objeto.categoria.colorHex.replaceFirst('#', '0xff')),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.gradientCardObjects,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _seccion(
                icono: Icons.category,
                titulo: 'Categoría',
                contenido: objeto.categoria.nombre,
              ),
              _seccion(
                icono: Icons.place,
                titulo: 'Ubicación',
                contenido: objeto.ubicacion,
              ),
              if (objeto.description.isNotEmpty)
                _seccion(
                  icono: Icons.description,
                  titulo: 'Descripción',
                  contenido: objeto.description,
                  expandirTexto: true,
                ),
              _seccion(
                icono: Icons.calendar_today,
                titulo: 'Fecha de guardado',
                contenido: formatearFecha(objeto.fecha),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: GradientOutlineButton(
                  text: "Editar Objeto",
                  contentPadding: EdgeInsets.all(15),
                  radius: 8.0,
                  borderGradient:  AppColors.gradientButtonPrimary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditObjectDialog(
                        objeto: objeto,
                        onEdit: (objActualizado) async {
                          // Actualizamos la lista global
                          AppData.instance.objects = AppData.instance.objects
                              .map((obj) {
                                return obj.nombre == objeto.nombre
                                    ? objActualizado
                                    : obj;
                              })
                              .toList();
                          await AppData.instance.saveObjects();

                          // Actualizamos la variable local y refrescamos la pantalla
                          setState(() {
                            objeto = objActualizado;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Objeto actualizado')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Confirmación antes de eliminar
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar objeto'),
                        content: const Text(
                          '¿Estás seguro de que quieres eliminar este objeto?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // Eliminamos el objeto de AppData
                      AppData.instance.objects.remove(widget.objeto);
                      await AppData.instance.storage.writeObjetos(
                        AppData.instance.objects,
                      );

                      // Volvemos a HomeScreen indicando que se eliminó
                      Navigator.pop(
                        context,
                        null,
                      ); // null indica que fue eliminado
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar objeto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

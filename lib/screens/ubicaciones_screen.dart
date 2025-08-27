import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/widgets/app_drawer.dart';

class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({super.key});

  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  List<String> ubicaciones = [];

  @override
  void initState() {
    super.initState();
    _loadUbicaciones();
  }

  Future<void> _loadUbicaciones() async {
    await AppData.instance.loadUbicaciones();
    setState(() {
      ubicaciones = List.from(AppData.instance.ubicaciones);
    });
  }

  Future<void> _deleteUbicacion(String ubic) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar ubicación'),
        content: const Text('¿Seguro que quieres eliminar esta ubicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = AppData.instance.eliminarUbicacion(ubic);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se puede eliminar "$ubic" porque hay objetos asociados.',
            ),
          ),
        );
      } else {
        await _loadUbicaciones();
        setState(() {});
      }
    }
  }

  Widget _buildUbicacionCard(String ubic) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientCardUbicaciones,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: const Icon(Icons.place, color: AppColors.iconsPrimary),
          title: Text(ubic, style: AppTextStyles.body),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteUbicacion(ubic),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Ubicaciones'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUbicaciones,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ubicaciones.isEmpty
            ? const Center(child: Text('No hay ubicaciones'))
            : ListView.builder(
                itemCount: ubicaciones.length,
                itemBuilder: (context, index) =>
                    _buildUbicacionCard(ubicaciones[index]),
              ),
      ),
    );
  }
}

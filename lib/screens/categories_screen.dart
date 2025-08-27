import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/models/categoria.dart';
import 'package:keepit/widgets/app_drawer.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List<Categoria> categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    await AppData.instance.loadCategorias();
    setState(() {
      categorias = List.from(AppData.instance.categorias);
    });
  }

  Future<void> _deleteCategoria(Categoria cat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: const Text('¿Seguro que quieres eliminar esta categoría?'),
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
      final success = AppData.instance.eliminarCategoria(cat);

      if (!success) {
        // Mostrar mensaje si no se pudo eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se puede eliminar "${cat.nombre}" porque hay objetos asociados.',
            ),
          ),
        );
      } else {
        // Recargar categorías si se eliminó correctamente
        await _loadCategorias();
        setState(() {});
      }
    }
  }

  Widget _buildCategoryCard(Categoria cat) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientCardCategory,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            Icons.category,
            color: Color(int.parse(cat.colorHex.replaceFirst('#', '0xff'))),
          ),
          title: Text(cat.nombre, style: AppTextStyles.body),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteCategoria(cat),
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
        title: const Text('Categorías'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCategorias,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categorias.isEmpty
            ? const Center(child: Text('No hay categorías'))
            : ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) =>
                    _buildCategoryCard(categorias[index]),
              ),
      ),
    );
  }
}

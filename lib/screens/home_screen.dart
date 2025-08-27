import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/global/app_data.dart';
import 'package:keepit/models/categoria.dart';
import 'package:keepit/models/objeto.dart';
import 'package:keepit/screens/detalle_objeto_screen.dart';
import 'package:keepit/widgets/add_category_dialog.dart';
import 'package:keepit/widgets/add_object_dialog.dart';
import 'package:keepit/widgets/add_ubicacion_dialog.dart';
import 'package:keepit/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Objeto> filteredObjects = [];
  List<Categoria> filteredCategories = [];
  List<String> filteredUbicaciones = [];
  final TextEditingController searchController = TextEditingController();

  String? selectedCategoria;
  String? selectedUbicacion;
  String? selectedOrden; // "Ultima", "A-Z", "Z-A"

  @override
  void initState() {
    super.initState();
    _loadObjetos();
    _loadCategories();
    _loadUbicaciones();
  }

  Future<void> _loadObjetos() async {
    await AppData.instance.loadObjects();
    setState(() {
      filteredObjects = List.from(AppData.instance.objects);
    });
  }

  Future<void> _loadCategories() async {
    await AppData.instance.loadCategorias();
    setState(() {
      filteredCategories = List.from(AppData.instance.categorias);
    });
  }

    Future<void> _loadUbicaciones() async {
    await AppData.instance.loadUbicaciones();
    setState(() {
      filteredUbicaciones = List.from(AppData.instance.ubicaciones);
    });
  }

  void _filterObjects(String query) {
    setState(() {
      filteredObjects = AppData.instance.objects
          .where(
            (obj) => obj.nombre.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _applyFilters() {
    List<Objeto> tempList = List.from(AppData.instance.objects);

    // Filtrar por búsqueda
    if (searchController.text.isNotEmpty) {
      tempList = tempList
          .where(
            (obj) => obj.nombre.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }

    // Filtrar por categoría
    if (selectedCategoria != null) {
      tempList = tempList
          .where((obj) => obj.categoria.nombre == selectedCategoria)
          .toList();
    }

    // Filtrar por ubicación
    if (selectedUbicacion != null) {
      tempList = tempList
          .where((obj) => obj.ubicacion == selectedUbicacion)
          .toList();
    }

    // Ordenar
    if (selectedOrden != null) {
      if (selectedOrden == "A-Z") {
        tempList.sort((a, b) => a.nombre.compareTo(b.nombre));
      } else if (selectedOrden == "Z-A") {
        tempList.sort((a, b) => b.nombre.compareTo(a.nombre));
      } else if (selectedOrden == "Ultima") {
        tempList.sort((a, b) => b.fecha.compareTo(a.fecha));
      }
    }

    setState(() {
      filteredObjects = tempList;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(labelText: 'Categoría', labelStyle: AppTextStyles.caption),
                value: selectedCategoria,
                items:
                    [null, ...AppData.instance.categorias.map((c) => c.nombre)]
                        .map(
                          (cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat ?? 'Todas', style: AppTextStyles.body),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  selectedCategoria = value;
                  _applyFilters();
                },
              ),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(labelText: 'Ubicación', labelStyle: AppTextStyles.caption),
                value: selectedUbicacion,
                items: [null, ...AppData.instance.ubicaciones]
                    .map(
                      (loc) => DropdownMenuItem<String>(
                        value: loc,
                        child: Text(loc ?? 'Todas', style: AppTextStyles.body),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedUbicacion = value;
                  _applyFilters();
                },
              ),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(labelText: 'Orden', labelStyle: AppTextStyles.caption),
                value: selectedOrden,
                items: [
                  DropdownMenuItem(value: null, child: Text('Sin orden', style: AppTextStyles.body)),
                  DropdownMenuItem(value: 'A-Z', child: Text('Nombre A-Z', style: AppTextStyles.body)),
                  DropdownMenuItem(value: 'Z-A', child: Text('Nombre Z-A', style: AppTextStyles.body)),
                  DropdownMenuItem(
                    value: 'Ultima',
                    child: Text('Última modificado', style: AppTextStyles.body),
                  ),
                ],
                onChanged: (value) {
                  selectedOrden = value;
                  _applyFilters();
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.gradientButtonPrimary,
                    ),
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        // Resetea los filtros aquí
                        setState(() {
                          filteredObjects = List.from(AppData.instance.objects);
                          selectedCategoria = null;
                          selectedUbicacion = null;
                          selectedOrden = null;
                        });
                        Navigator.pop(
                          context,
                        );
                        _showFilterDialog(); // vuelve a abrir el modal con items actualizados
                      },
                      child: const Text('Resetear filtros', style: AppTextStyles.button),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar', style: AppTextStyles.button),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddObjectDialog(
        onAdd: (Objeto nuevo) async {
          AppData.instance.addObject(nuevo);
          await _loadObjetos();
          setState(() {});
        },
      ),
    );
  }

  void _showAddCategoryDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
    if (result == true) {
      setState(() {}); // Refresca la UI si se agregó una categoría
    }
  }

  void _showAddUbicacionDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddUbicacionDialog(),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _showDetails(Objeto obj) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleObjetoScreen(objeto: obj)),
    );
    await _loadObjetos(); // Recargar objetos después de volver
  }

  Future<void> _deleteObjeto(Objeto obj) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar objeto'),
        content: const Text('¿Seguro que quieres eliminar este objeto?'),
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
      AppData.instance.removeObject(obj);
      await _loadObjetos();
    }
  }

  Widget _buildObjectCard(Objeto obj) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
                  gradient: AppColors.gradientCardObjects,
                  borderRadius: BorderRadius.circular(8)
                ),
        child: ListTile(
          leading: Icon(
            Icons.inventory,
            color: Color(
              int.parse(obj.categoria.colorHex.replaceFirst('#', '0xff')),
            ),
          ),
          title: Text(obj.nombre, style: AppTextStyles.title),
          subtitle: Text(obj.categoria.nombre, style: AppTextStyles.subtitle),
          onTap: () => _showDetails(obj),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteObjeto(obj),
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
        title: const Text('KeepIt'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: AppColors.iconsPrimary,
            onPressed: _loadObjetos,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: AppTextStyles.inputText,
                    decoration: const InputDecoration(
                      hintText: 'Buscar objeto...',
                      hintStyle: AppTextStyles.hintText,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.iconsPrimary,
                      ),
                    ),
                    onChanged: (_) => _applyFilters(),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: AppColors.iconsPrimary,
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredObjects.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay objetos',
                        style: AppTextStyles.subtitle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredObjects.length,
                      itemBuilder: (context, index) =>
                          _buildObjectCard(filteredObjects[index]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 3,
        overlayColor: AppColors.surfaceDark,
        gradient: AppColors.gradientButtonSecondary,
        gradientBoxShape: BoxShape.circle,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChildWidget('Agregar ubicación', Icons.place, _showAddUbicacionDialog),
          SpeedDialChildWidget('Agregar categoría', Icons.category, _showAddCategoryDialog),
          SpeedDialChildWidget('Agregar objeto', Icons.inventory_2, _showAddDialog),
        ],
      ),
    );
  }

  SpeedDialChild SpeedDialChildWidget(String text, IconData icon, Function()? onTap) {
    return SpeedDialChild(
          child: Icon(icon, color: AppColors.iconSpeedDial),
          label: text,
          onTap: onTap,
          backgroundColor: AppColors.surface,
          labelBackgroundColor: Colors.transparent,
          labelShadow: List.empty(growable: false),
          labelStyle: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.transparent,
          ),
        );
  }
}

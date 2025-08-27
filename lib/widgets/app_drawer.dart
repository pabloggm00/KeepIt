import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/screens/categories_screen.dart';
import 'package:keepit/screens/home_screen.dart';
import 'package:keepit/screens/ubicaciones_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 88, // Altura personalizada
            padding: EdgeInsets.only(top: 40, left: 30),
            color: AppColors.background,
            alignment: Alignment.centerLeft,
            child: const Text(
              'Menú',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.inventory,
              color: AppColors.iconsPrimary,
              size: 20,
            ),
            title: const Text('Objetos', style: AppTextStyles.drawerText),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.category,
              color: AppColors.iconsPrimary,
              size: 20,
            ),
            title: const Text('Categorías', style: AppTextStyles.drawerText),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CategoriasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.location_on,
              color: AppColors.iconsPrimary,
              size: 20,
            ),
            title: const Text('Ubicaciones', style: AppTextStyles.drawerText),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UbicacionesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

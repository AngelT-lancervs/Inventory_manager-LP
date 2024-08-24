import 'package:flutter/material.dart';
import 'package:inventory_manager/screens/details_screen.dart';
import 'package:inventory_manager/screens/product_list_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de pestañas (TabController) con dos pestañas
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Libera el controlador de pestañas cuando ya no se necesita
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Inventario'), // Título de la aplicación
        bottom: TabBar(
          controller: _tabController, // Controlador de pestañas
          tabs: const [
            Tab(text: 'Productos'), // Primera pestaña: Lista de productos
            Tab(text: 'Detalles'), // Segunda pestaña: Detalles del inventario
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Asocia el controlador de pestañas con el contenido
        children: const [
          ProductListScreen(), // Contenido de la primera pestaña: Lista de productos
          InventoryDetailsScreen(), // Contenido de la segunda pestaña: Detalles del inventario
        ],
      ),
    );
  }
}


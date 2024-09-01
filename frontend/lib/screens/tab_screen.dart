import 'package:flutter/material.dart';
import 'package:inventory_manager/screens/details_screen.dart';
import 'package:inventory_manager/screens/product_list_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with SingleTickerProviderStateMixin {
  // Controlador para manejar las pestañas
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de pestañas con dos pestañas
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Libera los recursos del controlador de pestañas cuando la pantalla se destruye
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // Color del icono del AppBar
        title: const Text('Gestión de Inventario', style: TextStyle(color: Colors.white),), // Título del AppBar
        backgroundColor: Colors.deepPurple, // Color personalizado del AppBar
        bottom: TabBar(
          controller: _tabController, // Controlador de pestañas
          indicatorColor: Colors.white, // Color del indicador de la pestaña seleccionada
          indicatorWeight: 4.0, // Grosor del indicador de la pestaña seleccionada
          labelColor: Colors.white, // Color del texto de la pestaña seleccionada
          unselectedLabelColor: Colors.white60, // Color del texto de las pestañas no seleccionadas
          tabs: const [
            Tab(
              icon: Icon(Icons.list), // Icono para la pestaña de productos
              text: 'Productos', // Texto para la pestaña de productos
            ),
            Tab(
              icon: Icon(Icons.info_outline), // Icono para la pestaña de detalles
              text: 'Detalles', // Texto para la pestaña de detalles
            ),
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

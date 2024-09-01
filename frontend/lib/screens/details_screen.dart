import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_manager/services/api_export.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  InventoryDetailsScreenState createState() => InventoryDetailsScreenState();
}

class InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  // Controladores de texto para los campos de nombre de inventario y creado por
  late TextEditingController _inventoryNameController;
  late TextEditingController _createdByController;

  // Variable para almacenar la fecha de creación
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();

    // Inicialización de los controladores con valores predeterminados
    _inventoryNameController = TextEditingController(text: "Inventario General");
    _createdByController = TextEditingController(text: "Administrador");
    _createdAt = DateTime.now(); // Fecha de creación inicial como la fecha actual
  }

  @override
  void dispose() {
    // Liberación de los recursos de los controladores al salir de la pantalla
    _inventoryNameController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  // Método para seleccionar la fecha de creación utilizando un DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2000), // Fecha mínima seleccionable
      lastDate: DateTime.now(), // Fecha máxima seleccionable (hoy)
    );
    if (picked != null && picked != _createdAt) {
      setState(() {
        _createdAt = picked; // Actualiza la fecha seleccionada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatear la fecha seleccionada para mostrarla
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Inventario'),
        automaticallyImplyLeading: false, // Elimina el botón de regreso predeterminado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Nombre del Inventario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _inventoryNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ingrese el nombre del inventario",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Creado por:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _createdByController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ingrese el nombre del creador",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fecha de Creación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Abre el DatePicker
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Llamada al servicio para descargar el archivo Excel
                    await ApiServiceDownload().downloadProductExcel(
                      _inventoryNameController.text,
                      _createdByController.text,
                      formattedDate,
                    );
                    // Muestra una notificación si la descarga es exitosa
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Archivo Excel generado y descargado.')),
                    );
                  } catch (e) {
                    // Muestra un mensaje de error si falla la descarga
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al generar el archivo Excel: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // Color del texto
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Borde redondeado
                  ),
                ),
                child: const Text('Generar Excel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

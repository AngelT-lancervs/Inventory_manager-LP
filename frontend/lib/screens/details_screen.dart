import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_manager/services/api_export.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  _InventoryDetailsScreenState createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  late TextEditingController _inventoryNameController;
  late TextEditingController _createdByController;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    
    // Valores por defecto
    _inventoryNameController = TextEditingController(text: "Inventario General");
    _createdByController = TextEditingController(text: "Administrador");
    _createdAt = DateTime.now();
  }

  @override
  void dispose() {
    _inventoryNameController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _createdAt) {
      setState(() {
        _createdAt = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Inventario'),
        automaticallyImplyLeading: false,
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
                  child: Text(formattedDate),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await ApiServiceDownload().downloadProductExcel(
                      _inventoryNameController.text,
                      _createdByController.text,
                      formattedDate,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Archivo Excel generado y descargado.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al generar el archivo Excel: $e')),
                    );
                  }
                },
                child: const Text('Generar Excel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

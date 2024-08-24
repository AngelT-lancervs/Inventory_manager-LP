import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';

class DraftListScreen extends StatefulWidget {
  const DraftListScreen({Key? key}) : super(key: key);

  @override
  _DraftListScreenState createState() => _DraftListScreenState();
}

class _DraftListScreenState extends State<DraftListScreen> {
  late Future<List<Map<String, dynamic>>> draftsFuture;

  @override
  void initState() {
    super.initState();
    draftsFuture = fetchDrafts(); // Carga inicial de los borradores
  }

  /// Método para obtener la lista de borradores desde el servidor
  Future<List<Map<String, dynamic>>> fetchDrafts() async {
    final url = Uri.parse('${url_global}drafts/'); // URL para obtener los borradores
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener borradores'); // Manejo de errores en la solicitud
    }
  }

  /// Método para eliminar un borrador específico por ID
  Future<void> deleteDraft(int draftId) async {
    final url = Uri.parse('${url_global}drafts/$draftId/'); // URL para eliminar un borrador
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      setState(() {
        draftsFuture = fetchDrafts(); // Recargar la lista de borradores después de la eliminación
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrador eliminado correctamente')), // Mostrar mensaje de éxito
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el borrador')), // Mostrar mensaje de error
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Borradores'), // Título de la pantalla
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: draftsFuture, // Futuro que contiene la lista de borradores
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Mostrar indicador de carga
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Mostrar mensaje de error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay borradores disponibles')); // Mensaje si no hay datos
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                final draft = snapshot.data![index];
                return ListTile(
                  title: Text(draft['name']), // Nombre del borrador
                  subtitle: Text('Fecha: ${draft['date']}'), // Fecha del borrador
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async {
                      // Mostrar un diálogo de confirmación antes de eliminar
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Borrador'),
                          content: const Text('¿Estás seguro de que deseas eliminar este borrador?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false), // Cerrar diálogo sin eliminar
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true), // Confirmar eliminación
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await deleteDraft(draft['id']); // Llamar a la función para eliminar el borrador
                      }
                    },
                  ),
                  onTap: () {
                    // Aquí puedes manejar la selección de un borrador si es necesario
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

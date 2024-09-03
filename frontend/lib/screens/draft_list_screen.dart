import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manager/core/constants.dart';
import 'package:inventory_manager/screens/draft_product_edit_screen.dart';

class DraftListScreen extends StatefulWidget {
  const DraftListScreen({super.key});

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
    final url =
        Uri.parse('${url_global}drafts/'); // URL para obtener los borradores
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(
          "Drafts fetched: $data"); // Depuración: Imprimir los borradores obtenidos
      return List<Map<String, dynamic>>.from(data);
    } else {
      print(
          "Error fetching drafts: ${response.statusCode}"); // Depuración: Error al obtener los borradores
      throw Exception(
          'Error al obtener borradores'); // Manejo de errores en la solicitud
    }
  }

  /// Método para marcar un borrador como completado
  Future<void> markDraftAsCompleted(int draftId) async {
    final url = Uri.parse(
        '${url_global}drafts/$draftId/complete/'); // URL para marcar como completado
    final response = await http.post(url);

    if (response.statusCode == 200) {
      print(
          "Draft $draftId marked as completed."); // Depuración: Confirmación de borrador marcado como completado
      setState(() {
        draftsFuture =
            fetchDrafts(); // Recargar la lista de borradores después de marcar como completado
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Borrador marcado como completado.')), // Mostrar mensaje de éxito
      );
    } else {
      print(
          "Error marking draft as completed: ${response.statusCode}"); // Depuración: Error al marcar como completado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error al marcar el borrador como completado.')), // Mostrar mensaje de error
      );
    }
  }

  /// Método para eliminar un borrador específico por ID
  Future<void> deleteDraft(int draftId) async {
    final url = Uri.parse(
        '${url_global}drafts/$draftId/'); // URL para eliminar un borrador
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      print(
          "Draft $draftId deleted."); // Depuración: Confirmación de borrador eliminado
      setState(() {
        draftsFuture =
            fetchDrafts(); // Recargar la lista de borradores después de la eliminación
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Borrador eliminado correctamente')), // Mostrar mensaje de éxito
      );
    } else {
      print(
          "Error deleting draft: ${response.statusCode}"); // Depuración: Error al eliminar el borrador
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error al eliminar el borrador')), // Mostrar mensaje de error
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
            return const Center(
                child:
                    CircularProgressIndicator()); // Mostrar indicador de carga
          } else if (snapshot.hasError) {
            print(
                "Error in FutureBuilder: ${snapshot.error}"); // Depuración: Error en FutureBuilder
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Mostrar mensaje de error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'No hay borradores disponibles')); // Mensaje si no hay datos
          } else {
            return ListView.builder(
              itemCount:
                  snapshot.data!.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                final draft = snapshot.data![index];
                final bool isCompleted = draft['completed'] ==
                    true; // Verificar si el borrador está completado
                print(
                    "Draft $index is completed: $isCompleted"); // Depuración: Imprimir el estado de completado
                return ListTile(
                  title: Text(
                    draft['name'],
                    style: TextStyle(
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted
                          ? Colors.green
                          : null, // Cambiar color si está completado
                    ),
                  ),
                  subtitle: Text('Fecha: ${draft['date']}'),
                  tileColor: isCompleted
                      ? Colors.green[50]
                      : null, // Cambiar el color de fondo si está completado
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isCompleted ? Icons.check_circle : Icons.check,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () async {
                          if (!isCompleted) {
                            await markDraftAsCompleted(
                                draft['id']); // Marcar como completado
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                          // Mostrar un diálogo de confirmación antes de eliminar
                          bool? confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar Borrador'),
                              content: const Text(
                                  '¿Estás seguro de que deseas eliminar este borrador?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(
                                      false), // Cerrar diálogo sin eliminar
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(true), // Confirmar eliminación
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            await deleteDraft(draft[
                                'id']); // Llamar a la función para eliminar el borrador
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DraftProductEditScreen(draft: draft),
                      ),
                    );
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

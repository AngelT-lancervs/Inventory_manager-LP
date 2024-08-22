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
    draftsFuture = fetchDrafts();
  }

  Future<List<Map<String, dynamic>>> fetchDrafts() async {
    final url = Uri.parse(
        '${url_global}drafts/'); // Asegúrate de usar la URL correcta
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener drafts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Borradores'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: draftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay borradores disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final draft = snapshot.data![index];
                return ListTile(
                  title: Text(draft['name']),
                  subtitle: Text('Fecha: ${draft['date']}'),
                  onTap: () {
                    // Aquí puedes manejar la selección de un draft
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

import 'package:inventory_manager/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiServiceDownload {
  final String baseUrl = "$url_global/";

  /// Método para generar el enlace de descarga del reporte de productos en formato Excel.
  Future<void> downloadProductExcel(String inventoryName, String createdBy, String createdAt) async {
    // Construir la URL con los parámetros
    final url = Uri.parse(
      '$baseUrl/download-excel?inventory_name=$inventoryName&created_by=$createdBy&created_at=$createdAt',
    );


    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';

class ApiProductRepository implements ProductRepositoryInterface {
  final Dio _dio = Dio();

  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_base_url');

    if (url == null || url.isEmpty) {
      throw Exception(
        'URL do servidor não configurada. Informe em configurações!',
      );
    }
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<Options?> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('api_user');
    final pass = prefs.getString('api_pass');

    if (user != null && user.isNotEmpty) {
      String basicAuth = 'Basic${base64Encode(utf8.encode('$user:$pass'))}';
      return Options(headers: {'autorization': basicAuth});
    }
    return null;
  }

  @override
  Future<List<Product>> importProducts() async {
    final baseUrl = await _getBaseUrl();
    final endpoint =
        '$baseUrl/exportacao/produtos'; // Rota definida no DJIntegração
    final options = await _getAuthOptions();

    try {
      final response = await _dio.get(
        endpoint,
        options:
            options?.copyWith(responseType: ResponseType.plain) ??
            Options(responseType: ResponseType.plain),
      );

      final String content = response.data.toString();
      final lines = LineSplitter.split(content).toList();
      final List<Product> list = [];

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          list.add(Product.fromTxtLine(line));
        } catch (e) {
          debugPrint('Erro de parse na API: $e');
        }
      }

      return list;
    } catch (e) {
      throw Exception('Erro ao buscar dados do servidor: $e');
    }
  }

  @override
  Future<void> saveProduct(List<Product> products) async {
    final baseUrl = await _getBaseUrl();
    final endpoint =
        '$baseUrl/importacao/produtos'; // Rota definida no DJIntegração
    final options = await _getAuthOptions();

    try {
      final buffer = StringBuffer();

      for (var product in products) {
        buffer.writeln(product.toTxtLine());
      }

      final fileContent = buffer.toString();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromString(
          fileContent,
          filename: 'PRODUTOS.TXT',
          contentType: DioMediaType.parse('text/plain'),
        ),
      });

      await _dio.post(endpoint, data: formData, options: options);
    } catch (e) {
      throw Exception('Erro ao enviar dados para o servidor: $e');
    }
  }
}

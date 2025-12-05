import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';

class ApiProductRepository implements ProductRepositoryInterface {
  final Dio _dio = Dio();

  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_base_url');
    if (url == null || url.isEmpty) {
      throw Exception('Servidor não configurado corretamente.');
    }
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  @override
  Future<List<Product>> importProducts() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get('$baseUrl/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception('Erro de conexão: ${e.message}');
      }
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  @override
  Future<void> saveProduct(List<Product> products) async {
    final baseUrl = await _getBaseUrl();

    try {
      final jsonList = products.map((p) => p.toJson()).toList();

      await _dio.put('$baseUrl/products', data: jsonList);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Erro ao enviar: ${e.message}');
      }
      throw Exception('Erro ao salvar produtos: $e');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';

class ApiProductRepository implements ProductRepositoryInterface {
  final Dio _dio = Dio();

  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_bae_url') ?? '';
  }

  @override
  Future<List<Product>> importProducts() async {
    final baseUrl = await _getBaseUrl();
    if (baseUrl.isEmpty) throw Exception('Configure o servidor primeiro');

    try {
      final response = await _dio.get('$baseUrl/products');
      final List<dynamic> data = response.data;
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro na API: $e');
    }
  }

  @override
  Future<void> saveProduct(List<Product> products) async {
    final baseUrl = await _getBaseUrl();

    try {
      final jsonList = products.map((p) => p.toJson()).toList();

      await _dio.put('$baseUrl/products', data: jsonList);
    } catch (e) {
      throw Exception('Erro ao salvar: $e');
    }
  }
}

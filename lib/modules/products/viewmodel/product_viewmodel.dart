import 'package:flutter/material.dart';
import 'package:asp/asp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';

class ProductViewmodel extends Disposable {
  final ProductRepositoryInterface repository;

  ProductViewmodel(this.repository);

  final productListState = atom<List<Product>>([]);
  final isLoadingState = atom<bool>(false);
  final statusMessageState = atom<String>('');

  late final _setList = atomAction1<List<Product>>((set, list) {
    set(productListState, list);
  });

  late final _setLoading = atomAction1<bool>((set, loading) {
    set(isLoadingState, loading);
  });

  late final _setMessage = atomAction1<String>((set, msg) {
    set(statusMessageState, msg);
  });

  Future<void> importFile() async {
    _setLoading(true);
    _setMessage('');

    try {
      final products = await repository.importProducts();

      _setList(products);
      _setMessage('Carregado: ${products.length} produtos.');
    } catch (e) {
      _setMessage('Erro ao importar: $e');
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void updateProductInMemory(Product editedProduct) {
    final currentList = productListState.state;
    final index = currentList.indexWhere((p) => p.id == editedProduct.id);

    if (index != -1) {
      final newList = List<Product>.from(currentList);
      newList[index] = editedProduct;

      _setList(newList);
    }
  }

  Future<void> saveFile() async {
    if (productListState.state.isEmpty) {
      _setMessage('Lista vazia, nada para salvar.');
      return;
    }

    _setLoading(true);
    try {
      await repository.saveProduct(productListState.state);
      _setMessage('Arquivo salvo/sincronizado com sucesso');
    } catch (e) {
      _setMessage('Erro ao salvar: $e');
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {}
}

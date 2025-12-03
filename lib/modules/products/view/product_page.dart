import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/products/viewmodel/products_viewmodel.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Modular.get<ProductsViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Produtos'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),

      body: AtomBuilder(
        builder: (context, get) {
          final isLoading = get(vm.isLoadingState);
          final list = get(vm.productListState);

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.list_alt, size: 60, color: Colors.grey),
                  Text('Nenhum produto carregado.'),
                  Text('Use o botão abaixo para importar o TXT.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final product = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[900],
                    child: Text(
                      product.unit,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(
                    product.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Cód: ${product.id} | Barras: ${product.barcode}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Est: ${product.stock.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: product.stock < 0
                              ? Colors.red
                              : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // modal
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btnImport',
            onPressed: vm.importFile,
            label: const Text('Importar TXT'),
            icon: const Icon(Icons.upload_file),
          ),
          const SizedBox(height: 15),
          FloatingActionButton.extended(
            heroTag: 'btnSave',
            backgroundColor: Colors.green[700],
            onPressed: vm.saveFile,
            label: const Text('Salvar Alterações'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      bottomNavigationBar: AtomBuilder(
        builder: (context, get) {
          final msg = get(vm.statusMessageState);

          if (msg.isNotEmpty) {
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(12),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

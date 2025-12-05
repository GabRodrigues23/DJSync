import 'package:flutter/material.dart';
import 'package:asp/asp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/products/viewmodel/product_viewmodel.dart';
import 'package:djsync/modules/products/widgets/product_editor_modal.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final vm = Modular.get<ProductViewmodel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.importFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Lista',
            onPressed: vm.importFile,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: () => Modular.to.navigate('/home'),
          ),
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
                children: [
                  const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'Nenhum produto encontrado.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: vm.importFile,
                    icon: const Icon(Icons.refresh),
                    label: const Text('TENTAR NOVAMENTE'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => vm.importFile(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final product = list[index];
                final isInactive = product.flag != 0;

                return Card(
                  elevation: 2,
                  color: isInactive ? Colors.grey[200] : Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isInactive
                          ? Colors.grey
                          : Colors.blue[900],
                      child: Text(
                        product.unit,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    title: Text(
                      product.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isInactive ? Colors.grey[600] : Colors.black,
                        decoration: isInactive
                            ? TextDecoration.lineThrough
                            : null,
                      ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isInactive ? Colors.grey : Colors.green,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Est: ${product.stock.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: product.stock <= 0
                                ? Colors.red
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => ProductEditorModal(product: product),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: vm.saveFile,
        backgroundColor: Colors.green[700],
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: const Text(
          'ENVIAR ALTERAÇÕES',
          style: TextStyle(color: Colors.white),
        ),
      ),

      bottomNavigationBar: AtomBuilder(
        builder: (context, get) {
          final msg = get(vm.statusMessageState);
          if (msg.isNotEmpty) {
            return Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(12),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

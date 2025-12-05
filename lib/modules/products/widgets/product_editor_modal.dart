import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:djsync/modules/products/viewmodel/product_viewmodel.dart';

class ProductEditorModal extends StatefulWidget {
  final Product product;

  const ProductEditorModal({super.key, required this.product});

  @override
  State<ProductEditorModal> createState() => _ProductEditorModalState();
}

class _ProductEditorModalState extends State<ProductEditorModal> {
  late TextEditingController _descController;
  late TextEditingController _barcodeController;
  late TextEditingController _unitController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _descController = TextEditingController(text: p.description);
    _barcodeController = TextEditingController(text: p.barcode);
    _unitController = TextEditingController(text: p.unit);
    _priceController = TextEditingController(text: p.price.toStringAsFixed(2));
    _stockController = TextEditingController(text: p.stock.toStringAsFixed(3));

    _isActive = p.flag == 0;
  }

  @override
  void dispose() {
    _descController.dispose();
    _barcodeController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _save() {
    final double newPrice =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ??
        widget.product.price;
    final double newStock =
        double.tryParse(_stockController.text.replaceAll(',', '.')) ??
        widget.product.stock;

    final editedProduct = widget.product.copyWith(
      description: _descController.text.toUpperCase(),
      barcode: _barcodeController.text,
      unit: _unitController.text.toUpperCase(),
      price: newPrice,
      stock: newStock,
      flag: _isActive ? 0 : -1,
    );

    Modular.get<ProductViewmodel>().updateProductInMemory(editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Produto'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${widget.product.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _descController,
            maxLength: 40,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _barcodeController,
            maxLength: 20,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cód Barras',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _unitController,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'UN',
                    counterText: '',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isActive ? 'Ativo' : 'Inativo',
                      style: TextStyle(
                        color: _isActive ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Preço (R\$)',
                    prefixText: 'R\$',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: TextField(
                  controller: _stockController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Estoque',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),

        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

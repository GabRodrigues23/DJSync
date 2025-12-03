class Product {
  final String id; // Cod. Externo (Pos 1-20)
  final String barcode; // Cod. Barras (Pos 21-40)
  final String description; // Descricao (Pos 41-80)
  final String unit; // Unidade (Pos 101-104)
  final double price; // Preco Venda (Pos 105-116) - 3 casas decimais
  final double stock; // Estoque (Pos 489-500) - casas decimais

  final String _fillerComplement; // Complemento (Pos 81-100)
  final String _fillerMid; // Desconto - KIT (Pos 117-488)
  final String _fillerFinal; // Prazo Devolucao - Validade (Pos 501-723)

  Product({
    required this.id,
    required this.unit,
    required this.barcode,
    required this.description,
    required this.price,
    required this.stock,

    required String fillerComplement,
    required String fillerMid,
    required String fillerFinal,
  }) : _fillerComplement = fillerComplement,
       _fillerMid = fillerMid,
       _fillerFinal = fillerFinal;

  Product copyWith({
    String? id,
    String? unit,
    String? barcode,
    String? description,
    double? price,
    double? stock,
  }) {
    return Product(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,

      fillerComplement: _fillerComplement,
      fillerMid: _fillerMid,
      fillerFinal: _fillerFinal,
    );
  }

  factory Product.fromTxtLine(String line) {
    if (line.length < 723) {
      line = line.padRight(723, ' ');
    }

    return Product(
      id: line.substring(0, 20).trim(),
      barcode: line.substring(20, 40).trim(),
      description: line.substring(40, 80).trim(),
      fillerComplement: line.substring(80, 110),
      unit: line.substring(100, 104).trim(),
      price:
          double.tryParse(
            line.substring(104, 116).trim().replaceAll(',', '.'),
          ) ??
          1.0,
      fillerMid: line.substring(116, 488),
      stock:
          double.tryParse(
            line.substring(488, 500).trim().replaceAll(',', '.'),
          ) ??
          0.0,
      fillerFinal: line.substring(500, 723),
    );
  }

  String toTxtLine() {
    String priceStr = price.toStringAsFixed(3).replaceAll('.', ',');
    String stockStr = price.toStringAsFixed(3).replaceAll('.', ',');

    return id.padRight(20, ' ') +
        barcode.padRight(20, ' ') +
        description.padRight(40, ' ') +
        _fillerComplement +
        unit.padRight(4, ' ') +
        priceStr.padLeft(12, '0') +
        _fillerMid +
        stockStr.padLeft(12, '0') +
        _fillerFinal;
  }
}

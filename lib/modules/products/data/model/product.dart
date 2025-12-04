class Product {
  final int id;
  final String code;
  final String barcode;
  final String description;
  final String unit;
  final double price;
  final double stock;
  final int flag;

  Product({
    required this.id,
    required this.code,
    required this.barcode,
    required this.description,
    required this.unit,
    required this.price,
    required this.stock,
    required this.flag,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['CODPRODUTO'] ?? 0,
      code: json['CODEXTERNO'] ?? '',
      barcode: json['CODBARRAS'] ?? '',
      description: json['DESCRICAO'] ?? '',
      unit: json['UN'] ?? 'UN',
      price: (json['PRECO_VENDA'] as num?)?.toDouble() ?? 1.0,
      stock: (json['QTD_ESTOQUE'] as num?)?.toDouble() ?? 0.0,
      flag: json['FLAG'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODPRODUTO': id,
      'CODBARRAS': barcode,
      'DESCRICAO': description,
      'UN': unit,
      'PRECO_VENDA': price,
      'ESTOQUE': stock,
      'FLAG': flag,
    };
  }

  Product copyWith({
    int? id,
    String? code,
    String? unit,
    String? barcode,
    String? description,
    double? price,
    double? stock,
    int? flag,
  }) {
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      flag: flag ?? this.flag,
    );
  }
}

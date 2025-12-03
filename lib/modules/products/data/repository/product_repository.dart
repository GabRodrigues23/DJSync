import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';
import 'package:djsync/modules/products/data/model/product.dart';
import 'package:flutter/material.dart';

class ProductRepository implements ProductRepositoryInterface {
  File? _currentFile;

  @override
  Future<List<Product>> importProducts() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.single.path != null) {
      _currentFile = File(result.files.single.path!);

      final lines = await _currentFile!.readAsLines(encoding: latin1);
      final List<Product> list = [];

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          list.add(Product.fromTxtLine(line));
        } catch (e) {
          debugPrint('Erro de parse: $e');
        }
      }
      return list;
    } else {
      throw Exception('Nenhum arquivo selecionado');
    }
  }

  @override
  Future<void> saveProduct(List<Product> products) async {
    if (_currentFile == null) {
      throw Exception('Nenhum arquivo carregado para salvar.');
    }

    final buffer = StringBuffer();
    for (var product in products) {
      buffer.writeln(product.toTxtLine());
    }
    await _currentFile!.writeAsString(buffer.toString(), encoding: latin1);
  }
}

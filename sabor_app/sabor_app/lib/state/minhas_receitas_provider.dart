import 'package:flutter/foundation.dart';
import '../models/receita.dart';

class MinhasReceitasProvider extends ChangeNotifier {
  final List<Receita> _receitas = [];
  List<Receita> get todos => List.unmodifiable(_receitas);

  void adicionar(Receita receita) {
    _receitas.add(receita);
    notifyListeners();
  }
}

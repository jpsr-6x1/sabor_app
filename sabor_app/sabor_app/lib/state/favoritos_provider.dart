import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/receita.dart';

class FavoritosProvider extends ChangeNotifier {
  static const _chave = 'favoritos';
  final Map<String, Receita> _favoritos = {};

  List<Receita> get todos => _favoritos.values.toList();
  int get total => _favoritos.length;
  bool ehFavorita(String id) => _favoritos.containsKey(id);

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final salvos = prefs.getStringList(_chave) ?? [];
    for (final texto in salvos) {
      final receita =
          Receita.fromJson(jsonDecode(texto) as Map<String, dynamic>);
      _favoritos[receita.id] = receita;
    }
    notifyListeners();
  }

  Future<void> alternar(Receita receita) async {
    if (ehFavorita(receita.id)) {
      _favoritos.remove(receita.id);
    } else {
      _favoritos[receita.id] = receita;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _chave, todos.map((r) => jsonEncode(r.toJson())).toList());
  }
}

Future<bool> confirmarRemocao(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remover dos favoritos?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Remover')),
          ],
        ),
      ) ??
      false;
}

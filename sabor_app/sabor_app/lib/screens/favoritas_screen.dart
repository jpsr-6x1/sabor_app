import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/favoritos_provider.dart';
import '../models/receita.dart';
import 'detalhe_screen.dart';

class FavoritasScreen extends StatelessWidget {
  const FavoritasScreen({super.key});

  Future<void> _remover(BuildContext context, Receita receita) async {
    final provider = context.read<FavoritosProvider>();
    if (await confirmarRemocao(context) &&
        context.mounted &&
        provider.ehFavorita(receita.id)) {
      await provider.alternar(receita);
    }
  }

  @override
  Widget build(BuildContext context) {
    final receitas = context.watch<FavoritosProvider>().todos;
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritas')),
      body: receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita favorita'))
          : ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, i) {
                final receita = receitas[i];
                return ListTile(
                  title: Text(receita.nome),
                  subtitle: Text(receita.tempoFormatado),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetalheScreen(receita: receita))),
                  trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      tooltip: 'Remover dos favoritos',
                      onPressed: () => _remover(context, receita)),
                );
              },
            ),
    );
  }
}

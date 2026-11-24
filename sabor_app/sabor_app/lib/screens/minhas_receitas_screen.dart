import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/minhas_receitas_provider.dart';
import 'nova_receita_screen.dart';
import 'detalhe_screen.dart';

class MinhasReceitasScreen extends StatelessWidget {
  const MinhasReceitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final receitas = context.watch<MinhasReceitasProvider>().todos;
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas receitas')),
      body: receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita cadastrada'))
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
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova receita',
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NovaReceitaScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

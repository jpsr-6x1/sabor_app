import 'package:flutter/material.dart';
import '../models/receita.dart';

class DetalheScreen extends StatelessWidget {
  final Receita receita;
  const DetalheScreen({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    final reserva = Container(
        height: 200,
        width: double.infinity,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: const Icon(Icons.restaurant, size: 80));
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: receita.imagemUrl.isEmpty
                    ? reserva
                    : Image.network(receita.imagemUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => reserva)),
            const SizedBox(height: 16),
            Text(receita.nome,
                style: Theme.of(context).textTheme.headlineSmall),
            Wrap(spacing: 8, runSpacing: 4, children: [
              Chip(label: Text(receita.categoria)),
              Chip(label: Text(receita.origem)),
              Chip(label: Text(receita.tempoFormatado)),
              Chip(label: Text(receita.dificuldade.rotulo)),
              Chip(label: Text('${receita.porcoes} porções')),
              if (receita.vegetariana) const Chip(label: Text('Vegetariana')),
            ]),
            const SizedBox(height: 16),
            Text('Ingredientes', style: Theme.of(context).textTheme.titleLarge),
            ...receita.ingredientes.map((ingrediente) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• $ingrediente'))),
            const SizedBox(height: 16),
            Text('Modo de preparo',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(receita.modoPreparo),
            const SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.favorite),
                    label: const Text('Favoritar'))),
          ])),
    );
  }
}

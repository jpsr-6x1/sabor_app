import 'package:flutter/material.dart';
import '../models/receita.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ReceitaCard(
      {super.key,
      required this.receita,
      required this.onTap,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final inicial = CircleAvatar(
        radius: 36, child: Text(receita.nome.isEmpty ? '?' : receita.nome[0]));
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
          ],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: receita.imagemUrl.isEmpty
                ? inicial
                : Image.network(receita.imagemUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => inicial),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(receita.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${receita.categoria} · ${receita.origem}',
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.timer, size: 15),
                  const SizedBox(width: 3),
                  Flexible(
                      child: Text(receita.tempoFormatado,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  const Icon(Icons.signal_cellular_alt, size: 15),
                  const SizedBox(width: 3),
                  Flexible(
                      child: Text(receita.dificuldade.rotulo,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                ]),
              ])),
          const Icon(Icons.chevron_right),
        ]),
      ),
    );
  }
}

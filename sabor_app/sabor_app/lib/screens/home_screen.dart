import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/receita_repository.dart';
import '../models/receita.dart';
import '../widgets/receita_card.dart';
import 'detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _termo = 'chicken';
  late Future<List<Receita>> _futuro;
  bool _emGrade = false;

  @override
  void initState() {
    super.initState();
    _futuro = context.read<ReceitaRepository>().buscar(_termo);
  }

  void _buscar(String termo) {
    setState(() {
      _termo = termo.trim();
      _futuro = context.read<ReceitaRepository>().buscar(_termo);
    });
  }

  void _abrirDetalhes(Receita receita) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => DetalheScreen(receita: receita)));
  }

  void _resumo(Receita receita) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Resumo rápido'),
              content: Text(
                  '${receita.nome}\nTempo: ${receita.tempoFormatado}\nPorções: ${receita.porcoes}\nIngredientes: ${receita.ingredientes.length}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'))
              ],
            ));
  }

  Widget _cardGrade(Receita receita) {
    final inicial = ColoredBox(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Center(
            child: Text(receita.nome.isEmpty ? '?' : receita.nome[0],
                style: const TextStyle(fontSize: 32))));
    return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _abrirDetalhes(receita),
          onLongPress: () => _resumo(receita),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                child: receita.imagemUrl.isEmpty
                    ? inicial
                    : Image.network(receita.imagemUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => inicial)),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(receita.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ])),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SaborApp'), actions: [
        IconButton(
            tooltip: _emGrade ? 'Exibir lista' : 'Exibir grade',
            icon: Icon(_emGrade ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _emGrade = !_emGrade)),
      ]),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar receitas',
                  border: OutlineInputBorder()),
              textInputAction: TextInputAction.search,
              onSubmitted: _buscar,
            )),
        Expanded(
            child: FutureBuilder<List<Receita>>(
          future: _futuro,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Erro ao buscar receitas'),
                ElevatedButton(
                    onPressed: () => _buscar(_termo),
                    child: const Text('Tentar novamente')),
              ]));
            }
            final receitas = snapshot.data ?? [];
            if (receitas.isEmpty) {
              return const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.search_off, size: 48),
                SizedBox(height: 8),
                Text('Nenhuma receita encontrada'),
              ]));
            }
            return _emGrade
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 180,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemCount: receitas.length,
                    itemBuilder: (_, i) => _cardGrade(receitas[i]))
                : ListView.builder(
                    itemCount: receitas.length,
                    itemBuilder: (_, i) => ReceitaCard(
                        receita: receitas[i],
                        onTap: () => _abrirDetalhes(receitas[i]),
                        onLongPress: () => _resumo(receitas[i])));
          },
        )),
      ]),
    );
  }
}

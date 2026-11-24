import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/receita.dart';
import '../state/minhas_receitas_provider.dart';

class NovaReceitaScreen extends StatefulWidget {
  const NovaReceitaScreen({super.key});

  @override
  State<NovaReceitaScreen> createState() => _NovaReceitaScreenState();
}

class _NovaReceitaScreenState extends State<NovaReceitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _tempoCtrl = TextEditingController();
  final _ingredientesCtrl = TextEditingController();
  final _preparoCtrl = TextEditingController();

  String? _categoria;
  Dificuldade _dificuldade = Dificuldade.facil;
  int _porcoes = 4;
  bool _vegetariana = false;

  List<String> get _ingredientes => _ingredientesCtrl.text
      .split('\n')
      .map((linha) => linha.trim())
      .where((linha) => linha.isNotEmpty)
      .toList();

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final receita = Receita(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeCtrl.text.trim(),
      categoria: _categoria!,
      origem: '—',
      tempoMinutos: int.parse(_tempoCtrl.text),
      dificuldade: _dificuldade,
      ingredientes: _ingredientes,
      modoPreparo: _preparoCtrl.text.trim(),
      porcoes: _porcoes,
      vegetariana: _vegetariana,
    );
    context.read<MinhasReceitasProvider>().adicionar(receita);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Receita salva!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _tempoCtrl.dispose();
    _ingredientesCtrl.dispose();
    _preparoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova receita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              controller: _nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (valor) => (valor ?? '').trim().length < 3
                  ? 'Informe pelo menos 3 caracteres'
                  : null,
            ),
            TextFormField(
              controller: _tempoCtrl,
              decoration: const InputDecoration(labelText: 'Tempo (min)'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (valor) {
                final tempo = int.tryParse(valor ?? '');
                return tempo == null || tempo < 1 || tempo > 600
                    ? 'Informe um tempo entre 1 e 600'
                    : null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: ['Prato principal', 'Sobremesa', 'Lanche', 'Bebida']
                  .map((categoria) => DropdownMenuItem(
                      value: categoria, child: Text(categoria)))
                  .toList(),
              onChanged: (valor) => setState(() => _categoria = valor),
              validator: (valor) =>
                  valor == null ? 'Selecione uma categoria' : null,
            ),
            const SizedBox(height: 16),
            const Text('Dificuldade'),
            SegmentedButton<Dificuldade>(
              segments: const [
                ButtonSegment(value: Dificuldade.facil, label: Text('Fácil')),
                ButtonSegment(value: Dificuldade.media, label: Text('Média')),
                ButtonSegment(
                    value: Dificuldade.dificil, label: Text('Difícil')),
              ],
              selected: {_dificuldade},
              onSelectionChanged: (valores) =>
                  setState(() => _dificuldade = valores.first),
            ),
            const SizedBox(height: 16),
            Text('Porções: $_porcoes'),
            Slider(
              value: _porcoes.toDouble(),
              min: 1,
              max: 12,
              divisions: 11,
              label: '$_porcoes',
              onChanged: (valor) => setState(() => _porcoes = valor.round()),
            ),
            SwitchListTile(
              title: const Text('Vegetariana'),
              value: _vegetariana,
              onChanged: (valor) => setState(() => _vegetariana = valor),
            ),
            TextFormField(
              controller: _ingredientesCtrl,
              decoration: const InputDecoration(
                  labelText: 'Ingredientes (um por linha)'),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              validator: (_) => _ingredientes.length < 2
                  ? 'Informe pelo menos 2 ingredientes'
                  : null,
            ),
            TextFormField(
              controller: _preparoCtrl,
              decoration: const InputDecoration(labelText: 'Modo de preparo'),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 6,
              validator: (valor) => (valor ?? '').trim().length < 20
                  ? 'Informe pelo menos 20 caracteres'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
          ]),
        ),
      ),
    );
  }
}

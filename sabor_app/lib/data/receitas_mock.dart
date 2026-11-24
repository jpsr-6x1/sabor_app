import '../models/receita.dart';

List<Receita> filtrarPorNome(List<Receita> receitas, String termo) {
  final busca = termo.trim().toLowerCase();
  if (busca.isEmpty) return receitas;
  return receitas.where((r) => r.nome.toLowerCase().contains(busca)).toList();
}

const List<Receita> receitasMock = [
  Receita(
      id: '1',
      nome: 'Pão de queijo',
      categoria: 'Lanche',
      tempoMinutos: 45,
      dificuldade: Dificuldade.facil),
  Receita(
      id: '2',
      nome: 'Brigadeiro',
      categoria: 'Sobremesa',
      tempoMinutos: 30,
      dificuldade: Dificuldade.facil),
  Receita(
      id: '3',
      nome: 'Feijoada',
      categoria: 'Prato principal',
      tempoMinutos: 90,
      dificuldade: Dificuldade.dificil),
  Receita(
      id: '4',
      nome: 'Moqueca',
      categoria: 'Prato principal',
      tempoMinutos: 75,
      dificuldade: Dificuldade.media),
  Receita(
      id: '5',
      nome: 'Salada de quinoa',
      categoria: 'Salada',
      tempoMinutos: 25,
      dificuldade: Dificuldade.facil),
  Receita(
      id: '6',
      nome: 'Suco verde',
      categoria: 'Bebida',
      tempoMinutos: 10,
      dificuldade: Dificuldade.facil),
];

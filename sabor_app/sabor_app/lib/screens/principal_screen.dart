import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/favoritos_provider.dart';
import 'home_screen.dart';
import 'favoritas_screen.dart';
import 'minhas_receitas_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    final total = context.watch<FavoritosProvider>().total;
    return Scaffold(
      body: IndexedStack(index: _indice, children: const [
        HomeScreen(),
        FavoritasScreen(),
        MinhasReceitasScreen(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (indice) => setState(() => _indice = indice),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.search), label: 'Explorar'),
          NavigationDestination(
            icon: Badge(
                label: Text('$total'),
                child: const Icon(Icons.favorite_border)),
            label: 'Favoritas',
          ),
          const NavigationDestination(
              icon: Icon(Icons.menu_book), label: 'Minhas receitas'),
        ],
      ),
    );
  }
}

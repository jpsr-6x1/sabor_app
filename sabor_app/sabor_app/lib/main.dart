import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'data/receita_repository.dart';
import 'state/favoritos_provider.dart';
import 'state/minhas_receitas_provider.dart';
import 'screens/principal_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favoritos = FavoritosProvider();
  await favoritos.carregar();
  runApp(MultiProvider(
    providers: [
      Provider<ReceitaRepository>(
          create: (_) => ReceitaRepositoryHttp(http.Client())),
      ChangeNotifierProvider.value(value: favoritos),
      ChangeNotifierProvider(create: (_) => MinhasReceitasProvider()),
    ],
    child: const SaborApp(),
  ));
}

class SaborApp extends StatelessWidget {
  const SaborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaborApp',
      debugShowCheckedModeBanner: false,
      home: const PrincipalScreen(),
    );
  }
}

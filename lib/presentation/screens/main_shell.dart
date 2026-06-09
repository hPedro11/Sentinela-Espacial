import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/risk_level.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import 'dashboard_tab.dart';
import 'events_tab.dart';
import 'favorites_tab.dart';
import 'settings_tab.dart';

// Estrutura principal do app: mantém a barra de navegação inferior e alterna
// entre as quatro abas, preservando o estado de cada uma (IndexedStack).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Carrega os dados uma única vez ao abrir o app.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AsteroidListViewModel>().fetchAsteroids();
      context.read<FavoritesViewModel>().loadFavorites();
    });
  }

  void _goTo(int index) => setState(() => _index = index);

  // Aplica um filtro de risco e leva o usuário à aba de listagem.
  void _showRisk(RiskLevel level) {
    context.read<AsteroidListViewModel>().setFilter(level);
    _goTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DashboardTab(onShowRisk: _showRisk),
      const EventsTab(),
      const FavoritesTab(),
      SettingsTab(onOpenFavorites: () => _goTo(2)),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'Asteroides',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

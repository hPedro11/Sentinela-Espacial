import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/risk_palette.dart';
import '../../domain/entities/risk_level.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/responsive_body.dart';

// Aba de configurações: atalhos (favoritos, alertas) e informações do app
// (fonte de dados e "sobre"), no mesmo estilo da referência.
class SettingsTab extends StatelessWidget {
  // Leva o usuário à aba de favoritos (definido pelo MainShell).
  final VoidCallback onOpenFavorites;

  const SettingsTab({super.key, required this.onOpenFavorites});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesViewModel>();
    final listViewModel = context.watch<AsteroidListViewModel>();
    final criticos = listViewModel.countFor(RiskLevel.critico);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ResponsiveBody(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Group(
            children: [
              _SettingTile(
                icon: Icons.favorite,
                iconColor: RiskPalette.critico,
                title: 'Eventos favoritados',
                subtitle: '${favorites.favoritesCount} salvos',
                trailing: const Icon(Icons.chevron_right,
                    color: AppTheme.textSecondary),
                onTap: onOpenFavorites,
              ),
              const Divider(height: 1),
              _SettingTile(
                icon: Icons.notifications_active,
                iconColor: AppTheme.navy,
                title: 'Alertas críticos',
                subtitle: '$criticos asteroides em risco crítico',
                onTap: () => _showCriticalAlerts(context, criticos),
                trailing: const Icon(Icons.chevron_right,
                    color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Group(
            children: [
              const _SettingTile(
                icon: Icons.satellite_alt,
                iconColor: AppTheme.navy,
                title: 'Fonte de dados',
                subtitle: 'NASA NeoWs (objetos próximos à Terra)',
              ),
              const Divider(height: 1),
              const _SettingTile(
                icon: Icons.info_outline,
                iconColor: AppTheme.navy,
                title: 'Sobre o Sentinela Espacial',
                subtitle: 'Global Solution 2026.1 — FIAP\nVersão 1.0',
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  void _showCriticalAlerts(BuildContext context, int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count > 0
              ? 'Existem $count asteroides classificados como CRÍTICO.'
              : 'Nenhum asteroide em risco crítico no momento.',
        ),
      ),
    );
  }
}

// Agrupador visual (card branco arredondado).
class _Group extends StatelessWidget {
  final List<Widget> children;

  const _Group({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: children),
    );
  }
}

// Linha de configuração reutilizável (ícone + título + subtítulo).
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ),
      trailing: trailing,
    );
  }
}

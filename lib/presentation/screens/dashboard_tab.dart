import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/risk_level.dart';
import '../routes/app_routes.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/view_state.dart';
import '../widgets/asteroid_list_item.dart';
import '../widgets/responsive_body.dart';
import '../widgets/risk_summary_card.dart';
import '../widgets/section_header.dart';
import '../widgets/state_views.dart';
import '../widgets/trend_chart.dart';

// Aba inicial (Dashboard): saudação, resumo de riscos, gráfico de tendência e
// asteroides recentes. Apenas observa a ViewModel.
class DashboardTab extends StatelessWidget {
  // Chamado ao tocar em um card de risco (aplica o filtro e abre a aba de
  // listagem). Definido pelo MainShell.
  final ValueChanged<RiskLevel> onShowRisk;

  const DashboardTab({super.key, required this.onShowRisk});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AsteroidListViewModel>();
    final favorites = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sentinela Espacial')),
      body: SafeArea(
        child: ResponsiveBody(
          child: _buildBody(context, viewModel, favorites),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsteroidListViewModel viewModel,
    FavoritesViewModel favorites,
  ) {
    if (viewModel.state == ViewState.error) {
      return ErrorView(
        message: viewModel.errorMessage ?? 'Ocorreu um erro.',
        onRetry: viewModel.fetchAsteroids,
      );
    }

    final isFirstLoad =
        viewModel.state == ViewState.loading && viewModel.totalCount == 0;

    return RefreshIndicator(
      onRefresh: viewModel.fetchAsteroids,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const _Greeting(),
          if (viewModel.isDemoData) ...[
            const SizedBox(height: 16),
            const _DemoBanner(),
          ],
          const SizedBox(height: 20),
          if (isFirstLoad)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: LoadingView(message: 'Consultando a NASA...'),
            )
          else ...[
            const SectionHeader(title: 'Resumo de riscos'),
            const SizedBox(height: 12),
            _RiskGrid(viewModel: viewModel, onShowRisk: onShowRisk),
            const SizedBox(height: 24),
            TrendChart(data: viewModel.trend),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Asteroides recentes'),
            const SizedBox(height: 12),
            ...viewModel.recent.map(
              (asteroid) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AsteroidListItem(
                  asteroid: asteroid,
                  isFavorite: favorites.isFavorite(asteroid.id),
                  onToggleFavorite: () =>
                      favorites.toggleFavorite(asteroid.id),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.asteroidDetail,
                    arguments: asteroid.id,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Aviso exibido quando os dados vêm do fallback local (API indisponível).
class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.navy.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: AppTheme.navy),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Exibindo dados de demonstração. A API da NASA está indisponível '
              '(sem conexão ou limite da DEMO_KEY atingido).',
              style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// Saudação no topo do dashboard, com chip da fonte de dados.
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Olá!', style: TextStyle(color: AppTheme.textSecondary)),
              SizedBox(height: 2),
              Text(
                'Visão geral',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Monitoramento de objetos próximos à Terra',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD7DBE3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.satellite_alt, size: 16, color: AppTheme.navy),
              SizedBox(width: 6),
              Text(
                'NASA NeoWs',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Grade 2x2 com o resumo de asteroides por nível de risco.
class _RiskGrid extends StatelessWidget {
  final AsteroidListViewModel viewModel;
  final ValueChanged<RiskLevel> onShowRisk;

  const _RiskGrid({required this.viewModel, required this.onShowRisk});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        for (final level in RiskLevel.values)
          RiskSummaryCard(
            level: level,
            count: viewModel.countFor(level),
            onTap: () => onShowRisk(level),
          ),
      ],
    );
  }
}

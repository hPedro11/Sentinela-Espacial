import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/view_state.dart';
import '../widgets/asteroid_list_item.dart';
import '../widgets/responsive_body.dart';
import '../widgets/risk_filter_chips.dart';
import '../widgets/state_views.dart';

// Aba de listagem de asteroides, com filtro por nível de risco, ordenação por
// maior risco e pull-to-refresh. Observa a ViewModel e renderiza cada estado.
class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AsteroidListViewModel>();
    final favorites = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroides'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: viewModel.fetchAsteroids,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: Column(
          children: [
            const SizedBox(height: 12),
            RiskFilterChips(
              selected: viewModel.filter,
              onChanged: viewModel.setFilter,
            ),
            Expanded(child: _buildBody(context, viewModel, favorites)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsteroidListViewModel viewModel,
    FavoritesViewModel favorites,
  ) {
    switch (viewModel.state) {
      case ViewState.initial:
      case ViewState.loading:
        return const LoadingView(message: 'Consultando a NASA...');
      case ViewState.error:
        return ErrorView(
          message: viewModel.errorMessage ?? 'Ocorreu um erro.',
          onRetry: viewModel.fetchAsteroids,
        );
      case ViewState.success:
        final asteroids = viewModel.asteroids;
        if (asteroids.isEmpty) {
          return const EmptyView(
            message: 'Nenhum asteroide encontrado para o filtro selecionado.',
          );
        }
        return RefreshIndicator(
          onRefresh: viewModel.fetchAsteroids,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: asteroids.length + 1,
            itemBuilder: (_, index) {
              if (index == 0) {
                return _ListHeader(count: asteroids.length);
              }
              final asteroid = asteroids[index - 1];
              return Padding(
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
              );
            },
          ),
        );
    }
  }
}

// Cabeçalho da lista: critério de ordenação e total de itens.
class _ListHeader extends StatelessWidget {
  final int count;

  const _ListHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ordenar: Maior risco',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            '$count asteroides',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

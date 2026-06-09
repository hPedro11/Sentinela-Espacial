import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/asteroid_list_item.dart';
import '../widgets/responsive_body.dart';
import '../widgets/state_views.dart';

// Aba de favoritos: lista apenas os asteroides marcados pelo usuário, lendo os
// dados persistidos (FavoritesViewModel) cruzados com a lista carregada.
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final listViewModel = context.watch<AsteroidListViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    final items = listViewModel.byIds(favorites.favoriteIds);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: ResponsiveBody(
        child: items.isEmpty
            ? const EmptyView(
                icon: Icons.favorite_border,
                message:
                    'Você ainda não favoritou nenhum asteroide.\nToque no coração na lista para salvar.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final asteroid = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AsteroidListItem(
                      asteroid: asteroid,
                      isFavorite: true,
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
      ),
    );
  }
}

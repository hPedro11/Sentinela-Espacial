import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

// ViewModel responsável pelo estado dos asteroides favoritos.
//
// Mantém em memória o conjunto de IDs favoritados e notifica a interface a cada
// alteração. Toda a regra de favoritar fica aqui, fora das telas.
class FavoritesViewModel extends ChangeNotifier {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  FavoritesViewModel(
    this._getFavoritesUseCase,
    this._toggleFavoriteUseCase,
  );

  Set<String> _favoriteIds = <String>{};
  Set<String> get favoriteIds => _favoriteIds;

  int get favoritesCount => _favoriteIds.length;

  bool isFavorite(String asteroidId) => _favoriteIds.contains(asteroidId);

  // Carrega os favoritos persistidos ao iniciar o app.
  Future<void> loadFavorites() async {
    _favoriteIds = await _getFavoritesUseCase.execute();
    notifyListeners();
  }

  // Alterna o favorito e atualiza o estado em memória.
  Future<void> toggleFavorite(String asteroidId) async {
    final isNowFavorite = await _toggleFavoriteUseCase.execute(asteroidId);
    if (isNowFavorite) {
      _favoriteIds.add(asteroidId);
    } else {
      _favoriteIds.remove(asteroidId);
    }
    notifyListeners();
  }
}

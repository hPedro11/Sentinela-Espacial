import '../repositories/favorites_repository.dart';

// Caso de uso: favoritar/desfavoritar um asteroide.
//
// Retorna o novo estado (true = agora é favorito).
class ToggleFavoriteUseCase {
  final FavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<bool> execute(String asteroidId) =>
      _repository.toggleFavorite(asteroidId);
}

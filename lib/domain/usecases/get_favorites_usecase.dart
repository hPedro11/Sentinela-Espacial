import '../repositories/favorites_repository.dart';

// Caso de uso: obter os IDs dos asteroides favoritados pelo usuário.
class GetFavoritesUseCase {
  final FavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Set<String>> execute() => _repository.getFavoriteIds();
}

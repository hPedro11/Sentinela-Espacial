// Contrato do repositório de favoritos.
//
// Responsável por persistir localmente os IDs dos asteroides marcados como
// favoritos pelo usuário (persistência via SharedPreferences na implementação).
abstract class FavoritesRepository {
  /// Retorna os IDs de todos os asteroides favoritados.
  Future<Set<String>> getFavoriteIds();

  /// Adiciona ou remove um asteroide dos favoritos e retorna o novo estado.
  Future<bool> toggleFavorite(String asteroidId);
}

import 'package:shared_preferences/shared_preferences.dart';

// Datasource local: persiste os favoritos do usuário usando SharedPreferences.
//
// Atende ao requisito de persistência local de dados, mantendo as escolhas do
// usuário mesmo após o app ser fechado.
class FavoritesLocalDatasource {
  static const String _key = 'favorite_asteroid_ids';

  // Lê os IDs favoritados salvos no dispositivo.
  Future<Set<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? <String>{};
  }

  // Alterna o estado de favorito de um asteroide e persiste a alteração.
  Future<bool> toggleFavorite(String asteroidId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key)?.toSet() ?? <String>{};

    final bool isNowFavorite;
    if (ids.contains(asteroidId)) {
      ids.remove(asteroidId);
      isNowFavorite = false;
    } else {
      ids.add(asteroidId);
      isNowFavorite = true;
    }

    await prefs.setStringList(_key, ids.toList());
    return isNowFavorite;
  }
}

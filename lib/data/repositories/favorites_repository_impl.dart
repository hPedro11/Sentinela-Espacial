import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

// Implementação concreta do repositório de favoritos, apoiada no datasource
// local (SharedPreferences).
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDatasource localDatasource;

  FavoritesRepositoryImpl(this.localDatasource);

  @override
  Future<Set<String>> getFavoriteIds() => localDatasource.getFavoriteIds();

  @override
  Future<bool> toggleFavorite(String asteroidId) =>
      localDatasource.toggleFavorite(asteroidId);
}

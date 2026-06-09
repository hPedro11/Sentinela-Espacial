import '../../domain/repositories/asteroid_repository.dart';
import '../datasources/asteroid_fallback_datasource.dart';
import '../datasources/asteroid_remote_datasource.dart';

// Implementação concreta do repositório de asteroides.
//
// Tenta primeiro a fonte remota (API da NASA). Em caso de falha (sem internet
// ou limite de requisições excedido), recorre ao fallback local para manter a
// aplicação utilizável, sinalizando que os dados são de demonstração.
class AsteroidRepositoryImpl implements AsteroidRepository {
  final AsteroidRemoteDatasource remoteDatasource;
  final AsteroidFallbackDatasource fallbackDatasource;

  AsteroidRepositoryImpl(this.remoteDatasource, this.fallbackDatasource);

  @override
  Future<AsteroidsResult> getAsteroids({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final asteroids = await remoteDatasource.getAsteroids(
        startDate: startDate,
        endDate: endDate,
      );
      return AsteroidsResult(asteroids: asteroids);
    } catch (_) {
      // A API falhou (ex.: HTTP 429 da DEMO_KEY) — usa dados de demonstração.
      return AsteroidsResult(
        asteroids: fallbackDatasource.getAsteroids(),
        isFallback: true,
      );
    }
  }
}

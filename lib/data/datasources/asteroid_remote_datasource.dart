import '../../core/http/http_client.dart';
import '../../domain/entities/asteroid.dart';
import '../models/asteroid_model.dart';

// Datasource remoto: acessa a API da NASA e transforma a resposta em entidades.
class AsteroidRemoteDatasource {
  final CustomHttpClient httpClient;

  // Injeção de dependência do client HTTP via construtor.
  AsteroidRemoteDatasource(this.httpClient);

  // Busca os asteroides no período informado e devolve a lista de entidades.
  Future<List<Asteroid>> getAsteroids({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await httpClient.getNeoFeed(
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
    );

    // A NASA agrupa os objetos por data dentro de "near_earth_objects".
    final data = response.data as Map<String, dynamic>;
    final byDate =
        (data['near_earth_objects'] ?? {}) as Map<String, dynamic>;

    final asteroids = <Asteroid>[];
    for (final entry in byDate.values) {
      final dailyList = (entry as List?) ?? const [];
      for (final item in dailyList) {
        asteroids.add(
          AsteroidModel.fromJson(item as Map<String, dynamic>).toEntity(),
        );
      }
    }
    return asteroids;
  }

  // Formata a data no padrão exigido pela API da NASA (YYYY-MM-DD).
  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

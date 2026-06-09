import '../entities/asteroid.dart';

// Resultado do carregamento de asteroides.
//
// Além da lista, informa se os dados vieram do fallback local (demonstração),
// permitindo que a interface avise o usuário.
class AsteroidsResult {
  final List<Asteroid> asteroids;
  final bool isFallback;

  const AsteroidsResult({required this.asteroids, this.isFallback = false});
}

// Contrato (abstração) do repositório de asteroides.
//
// A camada de apresentação depende desta interface, e não da implementação
// concreta, permitindo trocar a fonte de dados sem impactar o restante do app.
abstract class AsteroidRepository {
  /// Busca os asteroides próximos à Terra no período informado.
  Future<AsteroidsResult> getAsteroids({
    required DateTime startDate,
    required DateTime endDate,
  });
}

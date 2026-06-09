import '../repositories/asteroid_repository.dart';

// Caso de uso: obter a lista de asteroides próximos à Terra.
//
// Encapsula a regra de negócio e isola a ViewModel dos detalhes do repositório.
// Por padrão consulta a janela dos últimos 7 dias (limite do feed da NASA),
// o que também alimenta o gráfico de tendência do dashboard.
class GetAsteroidsUseCase {
  final AsteroidRepository _repository;

  GetAsteroidsUseCase(this._repository);

  Future<AsteroidsResult> execute({DateTime? reference}) {
    final today = reference ?? DateTime.now();
    final end = DateTime(today.year, today.month, today.day);
    final start = end.subtract(const Duration(days: 6));
    return _repository.getAsteroids(startDate: start, endDate: end);
  }
}

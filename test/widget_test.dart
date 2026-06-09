// Testes de unidade da AsteroidListViewModel: estados de carregamento,
// ordenação por proximidade e filtro de asteroides perigosos.

import 'package:flutter_test/flutter_test.dart';
import 'package:gs/domain/entities/asteroid.dart';
import 'package:gs/domain/entities/risk_level.dart';
import 'package:gs/domain/repositories/asteroid_repository.dart';
import 'package:gs/domain/usecases/get_asteroids_usecase.dart';
import 'package:gs/presentation/viewmodels/asteroid_list_viewmodel.dart';
import 'package:gs/presentation/viewmodels/view_state.dart';

// Repositório falso para testar a ViewModel sem acessar a rede.
class FakeAsteroidRepository implements AsteroidRepository {
  @override
  Future<AsteroidsResult> getAsteroids({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return const AsteroidsResult(
      asteroids: [_seguroDistante, _perigosoProximo],
    );
  }
}

void main() {
  late AsteroidListViewModel viewModel;

  setUp(() {
    viewModel = AsteroidListViewModel(
      GetAsteroidsUseCase(FakeAsteroidRepository()),
    );
  });

  test('classifica o risco do asteroide pela regra de domínio', () {
    // Perigoso e muito próximo (lunar < 10) => CRÍTICO.
    expect(_perigosoProximo.riskLevel, RiskLevel.critico);
    // Não perigoso, distante e pequeno => BAIXO.
    expect(_seguroDistante.riskLevel, RiskLevel.baixo);
  });

  test('carrega asteroides e entra no estado de sucesso', () async {
    expect(viewModel.state, ViewState.initial);
    await viewModel.fetchAsteroids();
    expect(viewModel.state, ViewState.success);
    expect(viewModel.totalCount, 2);
    expect(viewModel.countFor(RiskLevel.critico), 1);
    expect(viewModel.countFor(RiskLevel.baixo), 1);
  });

  test('ordena do maior para o menor risco', () async {
    await viewModel.fetchAsteroids();
    expect(viewModel.asteroids.first.id, '2');
  });

  test('filtro por nível retorna apenas o risco selecionado', () async {
    await viewModel.fetchAsteroids();
    viewModel.setFilter(RiskLevel.critico);
    expect(viewModel.asteroids.length, 1);
    expect(viewModel.asteroids.first.riskLevel, RiskLevel.critico);
  });
}

const _seguroDistante = Asteroid(
  id: '1',
  name: 'Seguro distante',
  absoluteMagnitude: 20,
  diameterMinMeters: 10,
  diameterMaxMeters: 20,
  isHazardous: false,
  closeApproachDate: '2026-06-02',
  velocityKmH: 1000,
  missDistanceKm: 9000000,
  missDistanceLunar: 23,
);

const _perigosoProximo = Asteroid(
  id: '2',
  name: 'Perigoso proximo',
  absoluteMagnitude: 18,
  diameterMinMeters: 100,
  diameterMaxMeters: 250,
  isHazardous: true,
  closeApproachDate: '2026-06-02',
  velocityKmH: 5000,
  missDistanceKm: 1000000,
  missDistanceLunar: 2.6,
);

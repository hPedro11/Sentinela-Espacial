import 'package:flutter/foundation.dart';

import '../../domain/entities/asteroid.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/usecases/get_asteroids_usecase.dart';
import 'view_state.dart';

// Contagem de eventos por nível de risco em um dia (alimenta o gráfico de
// tendência do dashboard).
class DayTrend {
  final String date;
  final Map<RiskLevel, int> counts;

  const DayTrend(this.date, this.counts);

  int get total => counts.values.fold(0, (sum, value) => sum + value);
}

// ViewModel da listagem de asteroides.
//
// Centraliza o estado da tela (carregando/sucesso/erro), os dados, o filtro de
// risco e os agregados (resumo e tendência). A View apenas observa este objeto.
class AsteroidListViewModel extends ChangeNotifier {
  final GetAsteroidsUseCase _getAsteroidsUseCase;

  AsteroidListViewModel(this._getAsteroidsUseCase);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<Asteroid> _asteroids = [];
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Indica que os dados exibidos vieram do fallback local (API indisponível).
  bool _isDemoData = false;
  bool get isDemoData => _isDemoData;

  // Filtro de risco selecionado (null = todos).
  RiskLevel? _filter;
  RiskLevel? get filter => _filter;

  // Lista filtrada e ordenada do maior para o menor risco (e mais próximos
  // primeiro em caso de empate).
  List<Asteroid> get asteroids {
    final list = _filter == null
        ? List<Asteroid>.from(_asteroids)
        : _asteroids.where((a) => a.riskLevel == _filter).toList();
    list.sort((a, b) {
      final byRisk = b.riskLevel.severity.compareTo(a.riskLevel.severity);
      if (byRisk != 0) return byRisk;
      return a.missDistanceKm.compareTo(b.missDistanceKm);
    });
    return list;
  }

  int get totalCount => _asteroids.length;

  // Quantidade de objetos em um determinado nível de risco (resumo).
  int countFor(RiskLevel level) =>
      _asteroids.where((a) => a.riskLevel == level).length;

  // Objetos mais recentes por data de aproximação (para "Asteroides recentes").
  List<Asteroid> get recent {
    final list = List<Asteroid>.from(_asteroids)
      ..sort((a, b) => b.closeApproachDate.compareTo(a.closeApproachDate));
    return list.take(4).toList();
  }

  // Série temporal dos últimos dias com a contagem por nível de risco.
  List<DayTrend> get trend {
    final byDate = <String, Map<RiskLevel, int>>{};
    for (final asteroid in _asteroids) {
      final day = asteroid.closeApproachDate;
      final counts = byDate.putIfAbsent(day, () => _emptyCounts());
      counts[asteroid.riskLevel] = (counts[asteroid.riskLevel] ?? 0) + 1;
    }
    final dates = byDate.keys.toList()..sort();
    return [for (final date in dates) DayTrend(date, byDate[date]!)];
  }

  Map<RiskLevel, int> _emptyCounts() =>
      {for (final level in RiskLevel.values) level: 0};

  // Busca os asteroides na API e atualiza os estados da tela.
  Future<void> fetchAsteroids() async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getAsteroidsUseCase.execute();
      _asteroids = result.asteroids;
      _isDemoData = result.isFallback;
      _state = ViewState.success;
    } catch (e) {
      _errorMessage =
          'Não foi possível carregar os dados da NASA. Verifique sua conexão e tente novamente.';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // Altera o filtro de risco aplicado à listagem.
  void setFilter(RiskLevel? filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  // Retorna os asteroides cujos IDs estão na lista informada (favoritos).
  List<Asteroid> byIds(Set<String> ids) {
    final list = _asteroids.where((a) => ids.contains(a.id)).toList();
    list.sort(
      (a, b) => b.riskLevel.severity.compareTo(a.riskLevel.severity),
    );
    return list;
  }

  // Localiza um asteroide pelo ID (usado pela tela de detalhes).
  Asteroid? findById(String id) {
    for (final asteroid in _asteroids) {
      if (asteroid.id == id) return asteroid;
    }
    return null;
  }
}

import 'risk_level.dart';

// Entidade de domínio que representa um asteroide próximo à Terra (NEO).
//
// É um objeto puro de domínio, independente de detalhes de API ou de UI.
class Asteroid {
  final String id;
  final String name;

  /// Magnitude absoluta (brilho intrínseco do objeto).
  final double absoluteMagnitude;

  /// Diâmetro estimado mínimo e máximo, em metros.
  final double diameterMinMeters;
  final double diameterMaxMeters;

  /// Indica se a NASA classifica o objeto como potencialmente perigoso.
  final bool isHazardous;

  /// Data da aproximação máxima com a Terra.
  final String closeApproachDate;

  /// Velocidade relativa, em km/h.
  final double velocityKmH;

  /// Distância de passagem da Terra, em km.
  final double missDistanceKm;

  /// Distância de passagem em distâncias lunares (1 = distância Terra-Lua).
  final double missDistanceLunar;

  const Asteroid({
    required this.id,
    required this.name,
    required this.absoluteMagnitude,
    required this.diameterMinMeters,
    required this.diameterMaxMeters,
    required this.isHazardous,
    required this.closeApproachDate,
    required this.velocityKmH,
    required this.missDistanceKm,
    required this.missDistanceLunar,
  });

  /// Diâmetro médio estimado, em metros (derivado das estimativas da NASA).
  double get averageDiameterMeters =>
      (diameterMinMeters + diameterMaxMeters) / 2;

  /// Classificação de risco do objeto, combinando a marcação de perigo da NASA
  /// com a proximidade (em distâncias lunares) e o tamanho estimado.
  ///
  /// É uma regra de negócio de domínio, mantida fora das telas.
  RiskLevel get riskLevel {
    if (isHazardous && missDistanceLunar < 10) return RiskLevel.critico;
    if (isHazardous) return RiskLevel.alto;
    if (missDistanceLunar < 10 || averageDiameterMeters > 150) {
      return RiskLevel.medio;
    }
    return RiskLevel.baixo;
  }
}

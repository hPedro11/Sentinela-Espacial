import '../../domain/entities/asteroid.dart';

// Model da camada de dados: conhece o formato JSON retornado pela API da NASA
// e sabe converter esse JSON na entidade de domínio [Asteroid].
class AsteroidModel {
  final String id;
  final String name;
  final double absoluteMagnitude;
  final double diameterMinMeters;
  final double diameterMaxMeters;
  final bool isHazardous;
  final String closeApproachDate;
  final double velocityKmH;
  final double missDistanceKm;
  final double missDistanceLunar;

  const AsteroidModel({
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

  // Constrói o model a partir de um item de "near_earth_objects" da NASA.
  factory AsteroidModel.fromJson(Map<String, dynamic> json) {
    final diameter = (json['estimated_diameter']?['meters'] ?? {})
        as Map<String, dynamic>;

    // O feed pode trazer várias aproximações; usamos a primeira disponível.
    final approaches = (json['close_approach_data'] as List?) ?? const [];
    final Map<String, dynamic> approach =
        approaches.isNotEmpty ? approaches.first as Map<String, dynamic> : {};

    final velocity =
        (approach['relative_velocity'] ?? {}) as Map<String, dynamic>;
    final missDistance =
        (approach['miss_distance'] ?? {}) as Map<String, dynamic>;

    return AsteroidModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Desconhecido',
      absoluteMagnitude: _toDouble(json['absolute_magnitude_h']),
      diameterMinMeters: _toDouble(diameter['estimated_diameter_min']),
      diameterMaxMeters: _toDouble(diameter['estimated_diameter_max']),
      isHazardous: json['is_potentially_hazardous_asteroid'] == true,
      closeApproachDate:
          approach['close_approach_date']?.toString() ?? 'Indisponível',
      velocityKmH: _toDouble(velocity['kilometers_per_hour']),
      missDistanceKm: _toDouble(missDistance['kilometers']),
      missDistanceLunar: _toDouble(missDistance['lunar']),
    );
  }

  // Converte o model em entidade de domínio.
  Asteroid toEntity() => Asteroid(
        id: id,
        name: name,
        absoluteMagnitude: absoluteMagnitude,
        diameterMinMeters: diameterMinMeters,
        diameterMaxMeters: diameterMaxMeters,
        isHazardous: isHazardous,
        closeApproachDate: closeApproachDate,
        velocityKmH: velocityKmH,
        missDistanceKm: missDistanceKm,
        missDistanceLunar: missDistanceLunar,
      );

  // Conversão defensiva: a API retorna alguns números como String.
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}

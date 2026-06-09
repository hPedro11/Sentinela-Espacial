import '../../domain/entities/asteroid.dart';

// Datasource de fallback (dados de demonstração).
//
// Usado apenas quando a API da NASA está indisponível (sem internet ou limite
// de requisições da DEMO_KEY excedido), garantindo que a aplicação continue
// utilizável — por exemplo, durante a gravação do vídeo Pitch.
//
// Os dados reproduzem o formato real do feed NeoWs, com datas distribuídas nos
// últimos 7 dias para alimentar também o gráfico de tendência.
class AsteroidFallbackDatasource {
  List<Asteroid> getAsteroids() {
    final today = DateTime.now();

    String day(int back) {
      final d = today.subtract(Duration(days: back));
      final m = d.month.toString().padLeft(2, '0');
      final dd = d.day.toString().padLeft(2, '0');
      return '${d.year}-$m-$dd';
    }

    // Cria um asteroide com distância lunar coerente com a distância em km.
    Asteroid mk(
      String id,
      String name,
      bool hazardous,
      double missKm,
      double velocityKmH,
      double diameterMin,
      double diameterMax,
      double magnitude,
      String date,
    ) {
      return Asteroid(
        id: id,
        name: name,
        absoluteMagnitude: magnitude,
        diameterMinMeters: diameterMin,
        diameterMaxMeters: diameterMax,
        isHazardous: hazardous,
        closeApproachDate: date,
        velocityKmH: velocityKmH,
        missDistanceKm: missKm,
        missDistanceLunar: missKm / 384400, // distância média Terra–Lua (km)
      );
    }

    return [
      // CRÍTICO (perigoso e muito próximo).
      mk('2099942', '99942 Apophis', true, 1850000, 38500, 310, 680, 19.7,
          day(0)),
      mk('3722000', '(2024 PT5)', true, 2480000, 41200, 280, 620, 20.1, day(3)),

      // ALTO (perigoso, porém mais distante).
      mk('2101955', '101955 Bennu', true, 18450000, 28900, 450, 510, 20.2,
          day(0)),
      mk('2410777', '410777 (2009 FD)', true, 24600000, 49500, 120, 270, 21.3,
          day(2)),
      mk('3837600', '(2015 FF)', true, 31200000, 53000, 130, 300, 22.0, day(5)),

      // MÉDIO (não perigoso, mas próximo ou grande).
      mk('2465633', '465633 (2009 JR5)', false, 2950000, 26100, 210, 480, 20.4,
          day(1)),
      mk('3092500', '(2010 RF12)', false, 1450000, 19800, 95, 210, 24.1, day(1)),
      mk('3789000', '(2014 JO25)', false, 3650000, 33700, 180, 410, 22.6,
          day(4)),
      mk('3102800', '(2011 ES4)', false, 2100000, 21200, 88, 197, 23.9, day(6)),
      mk('3621000', '(2013 TX68)', false, 4200000, 25400, 150, 330, 22.8,
          day(2)),

      // BAIXO (não perigoso, distante e pequeno).
      mk('3120100', '(2008 JV2)', false, 28760000, 22600, 18, 41, 26.3, day(0)),
      mk('3120200', '(2008 SY150)', false, 8330000, 24700, 24, 53, 25.7, day(0)),
      mk('3140500', '(2012 KT12)', false, 41200000, 18900, 12, 27, 27.1, day(1)),
      mk('3150900', '(2016 NF23)', false, 37800000, 32400, 30, 67, 24.9, day(2)),
      mk('3160300', '(2019 GT3)', false, 52300000, 17500, 9, 21, 27.8, day(3)),
      mk('3170800', '(2020 BX12)', false, 19600000, 20100, 15, 34, 26.6, day(3)),
      mk('3180400', '(2021 PH27)', false, 44100000, 36800, 22, 49, 25.2, day(4)),
      mk('3190600', '(2022 AP7)', false, 60500000, 29300, 27, 60, 24.6, day(5)),
      mk('3200100', '(2023 DZ2)', false, 6750000, 23800, 40, 90, 24.2, day(5)),
      mk('3210900', '(2018 VP1)', false, 33400000, 16400, 8, 18, 28.4, day(6)),
      mk('3220300', '(2017 BQ6)', false, 47800000, 31100, 19, 43, 25.9, day(6)),
      mk('3230700', '(2025 KA)', false, 25900000, 27600, 16, 36, 26.1, day(4)),
    ];
  }
}

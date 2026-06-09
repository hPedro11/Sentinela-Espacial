import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/risk_palette.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/asteroid.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/risk_badge.dart';
import '../widgets/info_tile.dart';
import '../widgets/responsive_body.dart';

// Tela de detalhes de um asteroide.
//
// Recebe o ID via argumentos de rota, recupera a entidade na ViewModel e exibe
// todos os atributos, permitindo favoritar/desfavoritar.
class AsteroidDetailScreen extends StatelessWidget {
  const AsteroidDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final asteroidId = ModalRoute.of(context)!.settings.arguments as String;
    final viewModel = context.read<AsteroidListViewModel>();
    final asteroid = viewModel.findById(asteroidId);

    if (asteroid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes')),
        body: const Center(child: Text('Asteroide não encontrado.')),
      );
    }

    final favorites = context.watch<FavoritesViewModel>();
    final isFavorite = favorites.isFavorite(asteroid.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do asteroide'),
        actions: [
          IconButton(
            tooltip: isFavorite
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',
            onPressed: () => favorites.toggleFavorite(asteroid.id),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailHeader(asteroid: asteroid),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  InfoTile(
                    icon: Icons.event,
                    label: 'Aproximação máxima',
                    value: asteroid.closeApproachDate,
                  ),
                  const Divider(height: 1),
                  InfoTile(
                    icon: Icons.social_distance,
                    label: 'Distância da Terra',
                    value: Formatters.distanceKm(asteroid.missDistanceKm),
                  ),
                  const Divider(height: 1),
                  InfoTile(
                    icon: Icons.brightness_3,
                    label: 'Distância (lunar)',
                    value:
                        '${Formatters.number(asteroid.missDistanceLunar, decimals: 1)} LD',
                  ),
                  const Divider(height: 1),
                  InfoTile(
                    icon: Icons.speed,
                    label: 'Velocidade relativa',
                    value: Formatters.velocity(asteroid.velocityKmH),
                  ),
                  const Divider(height: 1),
                  InfoTile(
                    icon: Icons.straighten,
                    label: 'Diâmetro estimado',
                    value:
                        '${Formatters.diameter(asteroid.diameterMinMeters)} – ${Formatters.diameter(asteroid.diameterMaxMeters)}',
                  ),
                  const Divider(height: 1),
                  InfoTile(
                    icon: Icons.light_mode,
                    label: 'Magnitude absoluta',
                    value: Formatters.number(
                      asteroid.absoluteMagnitude,
                      decimals: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _RiskExplanation(asteroid: asteroid),
        ],
        ),
      ),
    );
  }
}

// Cabeçalho da tela de detalhes com nome e selo de risco.
class _DetailHeader extends StatelessWidget {
  final Asteroid asteroid;

  const _DetailHeader({required this.asteroid});

  @override
  Widget build(BuildContext context) {
    final color = RiskPalette.color(asteroid.riskLevel);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(RiskPalette.icon(asteroid.riskLevel),
                  color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asteroid.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RiskBadge(level: asteroid.riskLevel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Texto explicativo sobre a classificação de risco do objeto.
class _RiskExplanation extends StatelessWidget {
  final Asteroid asteroid;

  const _RiskExplanation({required this.asteroid});

  @override
  Widget build(BuildContext context) {
    final color = RiskPalette.color(asteroid.riskLevel);
    final text = asteroid.isHazardous
        ? 'A NASA classifica este objeto como potencialmente perigoso devido à '
            'combinação de tamanho e proximidade da órbita terrestre. Objetos '
            'assim são prioritários no monitoramento de riscos.'
        : 'Este objeto não é classificado como perigoso pela NASA. Ainda assim, '
            'segue sendo monitorado pelas redes de observação espacial.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.4, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

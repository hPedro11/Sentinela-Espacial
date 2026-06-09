import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/risk_palette.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/asteroid.dart';
import 'risk_badge.dart';

// Item de lista reutilizável que representa um asteroide.
//
// Card branco com caixa de ícone colorida (pela cor do risco), nome, categoria,
// data, selo de risco e botão de favoritar. Desacoplado de navegação.
class AsteroidListItem extends StatelessWidget {
  final Asteroid asteroid;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const AsteroidListItem({
    super.key,
    required this.asteroid,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final color = RiskPalette.color(asteroid.riskLevel);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(RiskPalette.icon(asteroid.riskLevel),
                    color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            asteroid.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RiskBadge(level: asteroid.riskLevel),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Objeto próximo · ${Formatters.distanceKm(asteroid.missDistanceKm)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          asteroid.closeApproachDate,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        InkWell(
                          onTap: onToggleFavorite,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? RiskPalette.critico
                                  : AppTheme.textSecondary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

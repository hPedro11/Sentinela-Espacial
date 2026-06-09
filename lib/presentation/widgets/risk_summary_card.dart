import 'package:flutter/material.dart';

import '../../core/theme/risk_palette.dart';
import '../../domain/entities/risk_level.dart';

// Cartão colorido de resumo por nível de risco, usado no dashboard.
//
// Mostra o rótulo do nível, um ícone, a contagem de asteroides e a legenda.
class RiskSummaryCard extends StatelessWidget {
  final RiskLevel level;
  final int count;
  final VoidCallback? onTap;

  const RiskSummaryCard({
    super.key,
    required this.level,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = RiskPalette.color(level);
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    level.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(RiskPalette.icon(level), color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Asteroides',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

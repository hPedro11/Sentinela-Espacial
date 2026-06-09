import 'package:flutter/material.dart';

import '../../core/theme/risk_palette.dart';
import '../../domain/entities/risk_level.dart';

// Selo colorido reutilizável que indica o nível de risco de um asteroide.
class RiskBadge extends StatelessWidget {
  final RiskLevel level;

  const RiskBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = RiskPalette.color(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        level.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

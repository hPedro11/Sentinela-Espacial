import 'package:flutter/material.dart';

import '../../domain/entities/risk_level.dart';

// Mapeamento de cada nível de risco para sua identidade visual (cor e ícone).
//
// Mantém a aparência dos níveis de risco padronizada em toda a interface.
class RiskPalette {
  RiskPalette._();

  static const Color critico = Color(0xFFE23B3B);
  static const Color alto = Color(0xFFF1812F);
  static const Color medio = Color(0xFFF4B12A);
  static const Color baixo = Color(0xFF2E8B57);

  static Color color(RiskLevel level) => switch (level) {
        RiskLevel.critico => critico,
        RiskLevel.alto => alto,
        RiskLevel.medio => medio,
        RiskLevel.baixo => baixo,
      };

  static IconData icon(RiskLevel level) => switch (level) {
        RiskLevel.critico => Icons.local_fire_department,
        RiskLevel.alto => Icons.notifications_active,
        RiskLevel.medio => Icons.wb_sunny,
        RiskLevel.baixo => Icons.park,
      };
}

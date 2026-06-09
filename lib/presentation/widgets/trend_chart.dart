import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/risk_palette.dart';
import '../../domain/entities/risk_level.dart';
import '../viewmodels/asteroid_list_viewmodel.dart';

// Gráfico de tendência reutilizável (linhas por nível de risco ao longo dos
// dias). Desenhado com CustomPainter, sem dependências externas.
class TrendChart extends StatelessWidget {
  final List<DayTrend> data;

  const TrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tendência (7 dias)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: data.isEmpty
                  ? const Center(
                      child: Text(
                        'Sem dados para o período.',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    )
                  : CustomPaint(painter: _TrendPainter(data)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                for (final level in RiskLevel.values) _legend(level),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(RiskLevel level) {
    final label =
        '${level.label[0]}${level.label.substring(1).toLowerCase()}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: RiskPalette.color(level),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<DayTrend> data;

  _TrendPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // Maior valor entre todos os pontos (para normalizar o eixo Y).
    int maxValue = 1;
    for (final day in data) {
      for (final value in day.counts.values) {
        if (value > maxValue) maxValue = value;
      }
    }

    // Linha de base.
    final basePaint = Paint()
      ..color = const Color(0xFFE3E6EC)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      basePaint,
    );

    final stepX =
        data.length > 1 ? size.width / (data.length - 1) : size.width;

    for (final level in RiskLevel.values) {
      final paint = Paint()
        ..color = RiskPalette.color(level)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final dotPaint = Paint()..color = RiskPalette.color(level);

      final path = Path();
      for (int i = 0; i < data.length; i++) {
        final value = data[i].counts[level] ?? 0;
        final x = stepX * i;
        final y = size.height - (value / maxValue) * (size.height - 8);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.data != data;
}

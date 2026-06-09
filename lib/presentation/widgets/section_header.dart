import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

// Cabeçalho de seção reutilizável (ex.: "Resumo de riscos", "Asteroides
// recentes"), com título à esquerda e uma ação opcional à direita.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        ?trailing,
      ],
    );
  }
}

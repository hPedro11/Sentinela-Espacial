import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/risk_level.dart';

// Barra de chips reutilizável para filtrar a lista por nível de risco.
//
// O valor null representa "Todos".
class RiskFilterChips extends StatelessWidget {
  final RiskLevel? selected;
  final ValueChanged<RiskLevel?> onChanged;

  const RiskFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(context, label: 'Todos', value: null),
          for (final level in RiskLevel.values)
            _chip(context, label: level.label, value: level),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required RiskLevel? value,
  }) {
    final isSelected = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.navy : AppTheme.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFE7E9FB),
        side: BorderSide(
          color: isSelected ? AppTheme.navy : const Color(0xFFD7DBE3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (_) => onChanged(value),
      ),
    );
  }
}

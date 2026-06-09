import 'package:flutter/material.dart';

// Limita a largura do conteúdo e o centraliza.
//
// Mantém a aparência de aplicativo mobile mesmo em telas largas (web/desktop),
// evitando que cards e listas estiquem demais. Em celulares, ocupa toda a
// largura disponível.
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveBody({super.key, required this.child, this.maxWidth = 560});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

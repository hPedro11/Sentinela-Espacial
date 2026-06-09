// Funções utilitárias de formatação de números para exibição na interface.
class Formatters {
  Formatters._();

  // Formata um número com separador de milhar (padrão pt-BR) e casas decimais.
  static String number(double value, {int decimals = 0}) {
    final fixed = value.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts[0];

    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intPart[i]);
    }

    if (parts.length > 1) {
      buffer.write(',');
      buffer.write(parts[1]);
    }
    return buffer.toString();
  }

  // Distância em km formatada de forma amigável.
  static String distanceKm(double km) => '${number(km)} km';

  // Velocidade em km/h formatada.
  static String velocity(double kmH) => '${number(kmH)} km/h';

  // Diâmetro em metros formatado.
  static String diameter(double meters) => '${number(meters, decimals: 1)} m';
}

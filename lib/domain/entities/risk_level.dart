// Nível de risco de um evento/asteroide monitorado.
//
// Conceito de domínio reaproveitado em toda a aplicação (resumo, filtros,
// ordenação e selos visuais).
enum RiskLevel { critico, alto, medio, baixo }

extension RiskLevelX on RiskLevel {
  // Rótulo exibido na interface.
  String get label => switch (this) {
        RiskLevel.critico => 'CRÍTICO',
        RiskLevel.alto => 'ALTO',
        RiskLevel.medio => 'MÉDIO',
        RiskLevel.baixo => 'BAIXO',
      };

  // Peso usado para ordenar do maior para o menor risco.
  int get severity => switch (this) {
        RiskLevel.critico => 4,
        RiskLevel.alto => 3,
        RiskLevel.medio => 2,
        RiskLevel.baixo => 1,
      };
}

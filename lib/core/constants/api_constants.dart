// Constantes de configuração da API da NASA (NeoWs - Near Earth Object Web Service).
//
// A solução consome dados REAIS de asteroides próximos à Terra fornecidos pela
// NASA. A chave DEMO_KEY funciona para testes (limite de 30 requisições/hora).
// Para uso intenso, gere uma chave gratuita em https://api.nasa.gov e substitua
// o valor de [apiKey] abaixo.
class ApiConstants {
  ApiConstants._();

  /// URL base da API pública da NASA.
  static const String baseUrl = 'https://api.nasa.gov';

  /// Endpoint do feed de objetos próximos à Terra (NeoWs).
  static const String neoFeedPath = '/neo/rest/v1/feed';

  /// Chave de acesso à API da NASA.
  static const String apiKey = 'DEMO_KEY';
}

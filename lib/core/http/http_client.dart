import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

// Classe responsável por centralizar as requisições HTTP usando o pacote Dio.
//
// Mantém a configuração de baseUrl e timeouts em um único lugar, deixando os
// datasources livres de detalhes de infraestrutura de rede.
class CustomHttpClient {
  final Dio dio;

  // Inicializa o client Dio com a configuração base da API da NASA.
  CustomHttpClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  // Realiza requisição GET para o feed de asteroides próximos à Terra.
  //
  // [startDate] e [endDate] delimitam o período consultado (formato YYYY-MM-DD).
  Future<Response> getNeoFeed({
    required String startDate,
    required String endDate,
  }) async {
    return dio.get(
      ApiConstants.neoFeedPath,
      queryParameters: {
        'start_date': startDate,
        'end_date': endDate,
        'api_key': ApiConstants.apiKey,
      },
    );
  }
}

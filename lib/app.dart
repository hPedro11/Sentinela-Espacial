import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/http/http_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/asteroid_fallback_datasource.dart';
import 'data/datasources/asteroid_remote_datasource.dart';
import 'data/datasources/favorites_local_datasource.dart';
import 'data/repositories/asteroid_repository_impl.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'domain/usecases/get_asteroids_usecase.dart';
import 'domain/usecases/get_favorites_usecase.dart';
import 'domain/usecases/toggle_favorite_usecase.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/screens/asteroid_detail_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/viewmodels/asteroid_list_viewmodel.dart';
import 'presentation/viewmodels/favorites_viewmodel.dart';

// Widget raiz do aplicativo.
//
// Responsável pela injeção de dependências (montagem das camadas data → domain
// → presentation), pelo registro das ViewModels via Provider e pela
// configuração das rotas nomeadas.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // ----- Camada de infraestrutura / dados -----
    final httpClient = CustomHttpClient();
    final asteroidRemoteDatasource = AsteroidRemoteDatasource(httpClient);
    final asteroidFallbackDatasource = AsteroidFallbackDatasource();
    final favoritesLocalDatasource = FavoritesLocalDatasource();

    final asteroidRepository = AsteroidRepositoryImpl(
      asteroidRemoteDatasource,
      asteroidFallbackDatasource,
    );
    final favoritesRepository =
        FavoritesRepositoryImpl(favoritesLocalDatasource);

    // ----- Camada de domínio (casos de uso) -----
    final getAsteroidsUseCase = GetAsteroidsUseCase(asteroidRepository);
    final getFavoritesUseCase = GetFavoritesUseCase(favoritesRepository);
    final toggleFavoriteUseCase = ToggleFavoriteUseCase(favoritesRepository);

    // ----- Camada de apresentação (ViewModels via Provider) -----
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AsteroidListViewModel(getAsteroidsUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(
            getFavoritesUseCase,
            toggleFavoriteUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Sentinela Espacial',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const MainShell(),
          AppRoutes.asteroidDetail: (_) => const AsteroidDetailScreen(),
        },
      ),
    );
  }
}

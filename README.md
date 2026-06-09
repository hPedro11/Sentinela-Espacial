# Sentinela Espacial 🛰️

Aplicação **Flutter (cross platform)** desenvolvida para a **Global Solution 2026.1 – FIAP**, disciplina **Desenvolvimento Cross Platform**, com o tema **"Indústria Espacial"**.

---

## 📌 Descrição da solução

O **Sentinela Espacial** é um aplicativo de **monitoramento de asteroides próximos à Terra (NEOs – Near Earth Objects)** que consome **dados reais e dinâmicos da NASA** (API pública *NeoWs – Near Earth Object Web Service*).

A solução conecta a **economia/indústria espacial** a um problema real aqui na Terra: a **prevenção de riscos e desastres**. Usando dados de observação espacial, o app lista os objetos que se aproximam do planeta, destaca os **potencialmente perigosos** e permite que o usuário acompanhe e favorite os objetos de interesse.

> Alinhamento com os **ODS da ONU**: **ODS 9** (Indústria, inovação e infraestrutura) e **ODS 13** (Ação contra a mudança global do clima), por meio do uso de dados espaciais para apoio à decisão e gestão de riscos.

## 🎯 Proposta da aplicação

- Transformar dados orbitais brutos da NASA em informação **clara e acionável**.
- Oferecer uma visão rápida (**dashboard**) do monitoramento do dia: total de objetos próximos, quantos são perigosos e quantos o usuário favoritou.
- Permitir **explorar, filtrar e detalhar** cada asteroide (distância, velocidade, diâmetro, data de aproximação, magnitude).
- **Persistir** localmente os asteroides favoritados, mantendo a escolha do usuário entre sessões.

## 👥 Integrantes do grupo

| Nome                         | RM      |
|------------------------------|---------|
| Pedro Henrique Lima          | 553664  |
| Maria Alice Sousa Santos     | 552717  |
| Thaís Mari Costa Lopes       | 553620  |

---

## 🧭 Fluxo de telas

A navegação principal usa uma **barra inferior** com 4 abas, mais uma tela de **detalhes** acessível ao tocar em qualquer asteroide:

```
 Barra inferior (NavigationBar)
 ┌───────────┬────────────┬───────────┬───────────────┐
 │ Dashboard │ Asteroides │ Favoritos │ Configurações │
 └─────┬─────┴──────┬─────┴─────┬─────┴───────┬───────┘
       │            │           │             │
   resumo de     lista com   favoritos     fonte de
   riscos +      filtro por  persistidos   dados + sobre
   tendência +   nível de    (Shared        + atalhos
   recentes      risco       Preferences)
       │            │           │
       └────────────┴───────────┘──► AsteroidDetailScreen (detalhes + favoritar)
```

1. **Dashboard:** saudação, **resumo de riscos** (CRÍTICO/ALTO/MÉDIO/BAIXO), **gráfico de tendência (7 dias)** e asteroides recentes.
2. **Asteroides:** lista vinda da API, com **chips de filtro** por nível de risco, ordenação por maior risco, **pull-to-refresh** e **favoritar**.
3. **Favoritos:** mostra apenas os asteroides salvos (persistidos localmente).
4. **Configurações:** atalhos (favoritos, alertas críticos) e informações do app (fonte de dados e "sobre").
5. **Detalhes:** todos os atributos do asteroide selecionado, com selo de risco e explicação.

> Os asteroides são classificados em **CRÍTICO / ALTO / MÉDIO / BAIXO** combinando a marcação de perigo da NASA com a proximidade (em distâncias lunares) e o tamanho estimado.

## 🌐 API utilizada

- **NASA NeoWs (Near Earth Object Web Service)**
  - Endpoint: `GET https://api.nasa.gov/neo/rest/v1/feed`
  - Documentação / chave gratuita: <https://api.nasa.gov>
- A aplicação trata explicitamente os **quatro estados** do consumo de dados: **inicial, carregando, sucesso e erro** (com botão *tentar novamente*).
- Os dados exibidos são **dinâmicos** (vêm da API a cada consulta).

> A chave configurada é a `DEMO_KEY` (limite de **30 req/hora**). Ao atingir o limite, a API responde **HTTP 429**. Para uso contínuo, gere uma **chave gratuita** em <https://api.nasa.gov> (sobe para 1.000 req/hora) e substitua o valor em [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart).

### Resiliência (fallback)

Se a API estiver indisponível (sem internet ou limite da `DEMO_KEY` atingido), a aplicação **não quebra**: ela recorre a um **fallback local** com dados de demonstração e exibe um aviso na tela inicial. Assim que a API volta a responder, os dados ao vivo são usados novamente. A fonte principal de dados continua sendo o WebService da NASA.

## 🏛️ Arquitetura (MVVM + camadas)

O projeto segue **MVVM** organizado em camadas com clara **separação de responsabilidades**. As **regras de negócio ficam fora das telas** (nas ViewModels e casos de uso), e a navegação é centralizada em rotas nomeadas.

```
lib/
├── main.dart                      # Ponto de entrada
├── app.dart                       # Injeção de dependências, Providers e rotas
├── core/                          # Infraestrutura compartilhada
│   ├── constants/                 # Constantes da API
│   ├── http/                      # CustomHttpClient (Dio)
│   ├── theme/                     # Tema visual centralizado
│   └── utils/                     # Formatadores
├── data/                          # MODEL (acesso a dados)
│   ├── datasources/               # Remoto (NASA) e local (SharedPreferences)
│   ├── models/                    # AsteroidModel (JSON ↔ entidade)
│   └── repositories/              # Implementações dos repositórios
├── domain/                        # Regras e contratos de negócio
│   ├── entities/                  # Asteroid (entidade pura)
│   ├── repositories/              # Interfaces (abstrações)
│   └── usecases/                  # Casos de uso
└── presentation/                  # VIEW + VIEWMODEL
    ├── viewmodels/                # AsteroidListViewModel, FavoritesViewModel, ViewState
    ├── screens/                   # MainShell + abas (Dashboard, Events, Favorites, Settings) + Detalhes
    ├── widgets/                   # Componentes reutilizáveis (cards, chips, badge, gráfico...)
    └── routes/                    # Rotas nomeadas
```

**Mapeamento MVVM:**

| Camada MVVM   | Onde está no projeto                                   |
|---------------|--------------------------------------------------------|
| **Model**     | `data/` + `domain/` (entidades, modelos, repositórios) |
| **View**      | `presentation/screens/` + `presentation/widgets/`      |
| **ViewModel** | `presentation/viewmodels/` (`ChangeNotifier`)          |

**Fluxo de dados:** `View` → `ViewModel` → `UseCase` → `Repository` → `DataSource` → API/SharedPreferences.

### Tecnologias e pacotes

- **Flutter / Dart**
- **provider** – gerenciamento de estado (MVVM com `ChangeNotifier`)
- **dio** – consumo de WebService (HTTP)
- **shared_preferences** – persistência local dos favoritos

---

## ✅ Atendimento aos requisitos da disciplina

| # | Requisito | Como foi atendido |
|---|-----------|-------------------|
| 1 | Estruturação e arquitetura (MVVM) | Camadas `core/data/domain/presentation`, ViewModels com `ChangeNotifier`, rotas centralizadas, sem regra de negócio nas telas |
| 2 | Interface e navegação | Dashboard, listagem, favoritos, configurações e detalhes; barra de navegação inferior + rotas nomeadas; layout responsivo e consistente (tema claro profissional) |
| 3 | Consumo de API | NASA NeoWs via Dio, com tratamento de estado inicial/carregando/sucesso/erro e dados dinâmicos |
| 4 | Persistência de dados | Favoritos persistidos com `SharedPreferences`, integrados à interface (aba Favoritos) |
| 5 | Componentização | Widgets reutilizáveis (`AsteroidListItem`, `RiskSummaryCard`, `RiskBadge`, `RiskFilterChips`, `TrendChart`, `SectionHeader`, `InfoTile`, `LoadingView`/`ErrorView`/`EmptyView`) |
| 6 | Funcionalidades | Listagem dinâmica, filtro por risco, classificação de risco, gráfico de tendência, atualização (refresh), favoritar |
| 7 | Boas práticas | Nomeação clara, separação de responsabilidades, `flutter analyze` sem issues e testes de unidade |

---

## ▶️ Como executar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Executar (Android / iOS / Web / Desktop)
flutter run

# 3. (Opcional) Rodar a análise estática e os testes
flutter analyze
flutter test
```

> Requer conexão com a internet para consumir a API da NASA.

## 🧪 Qualidade

- `flutter analyze` → **No issues found**
- `flutter test` → testes de unidade da ViewModel (estados, ordenação e filtro) passando

---

*Projeto acadêmico desenvolvido para a Global Solution FIAP 2026.1 — Indústria Espacial.*

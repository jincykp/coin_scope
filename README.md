# CoinScope – Crypto Market & Research App

CoinScope is a Flutter-based cryptocurrency market and research application that provides cryptocurrency information using the CoinGecko API. Users can explore cryptocurrency prices, track market performance, view detailed coin information, analyze price charts, and manage their watchlist.

## Features

- **Crypto Market:** Browse cryptocurrencies with price, market capitalization, trading volume, and 24-hour price changes.
- **Search:** Search cryptocurrencies by name or symbol.
- **Filter & Sort:** Filter gainers and losers and sort coins by market capitalization, price, and percentage change.
- **Coin Details:** View detailed market information, supply, all-time high (ATH), all-time low (ATL), and coin description.
- **Interactive Price Charts:** Analyze historical price movements across different time periods (1D, 7D, 1M, 3M, and 1Y).
- **Watchlist:** Add or remove favorite cryptocurrencies with locally persisted data.
- **Market Statistics:** View global cryptocurrency market capitalization, trading volume, Bitcoin and Ethereum dominance, and market sentiment.
- **Loading & Error States:** User-friendly loading indicators, error messages, and empty states.

## Packages & Technologies Used

| Package / Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile development |
| Dart | Programming language |
| flutter_bloc | State management |
| equatable | Value comparison for BLoC events and states |
| dio | REST API integration |
| shared_preferences | Local watchlist storage |
| fl_chart | Interactive price charts |
| intl | Number and currency formatting |
| cached_network_image | Network image caching |
| get_it | Dependency injection |

## Architecture

The project follows **Clean Architecture**, separating the application into three main layers:

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── routes/
│   └── theme/
│
├── features/
│   ├── splash/
│   ├── home/
│   ├── market/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── coin_details/
│   ├── coin_chart/
│   ├── watchlist/
│   ├── statistics/
│   └── profile/
│
└── main.dart
```

- **Presentation Layer:** Screens, widgets, BLoC events, and states.
- **Domain Layer:** Entities, repository contracts, and use cases.
- **Data Layer:** API data sources, models, and repository implementations.

## API Integration

CoinScope uses the [CoinGecko API](https://www.coingecko.com/en/api) to retrieve cryptocurrency market information.

| Endpoint | Purpose |
|---|---|
| `/coins/markets` | Cryptocurrency market listings |
| `/coins/{id}` | Detailed cryptocurrency information |
| `/coins/{id}/market_chart` | Historical price chart data |
| `/global` | Global cryptocurrency market statistics |

API Documentation: [CoinGecko API](https://docs.coingecko.com/)

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- CoinGecko Demo API key

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/jincykp/coin_scope.git
   ```

2. Navigate to the project directory:

   ```bash
   cd coin_scope
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Configure your CoinGecko API key using your local API configuration.

   **Note:** Do not commit API keys or other sensitive information to GitHub.

5. Run the application:

   ```bash
   flutter run
   ```

## Data Attribution

Cryptocurrency market data is provided by [CoinGecko](https://www.coingecko.com/).

## Author

**Jincy K P**

- GitHub: [github.com/jincykp](https://github.com/jincykp)
- LinkedIn: [linkedin.com/in/jincykp](https://linkedin.com/in/jincykp)

---

*Built with Flutter and Dart.*
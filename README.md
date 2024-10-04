# Flutter Trading Instruments App

This Flutter application displays a list of trading instruments along with a real-time price ticker. It uses the Finnhub API to fetch instrument data and receive live price updates.

## Features

- Display a list of trading instruments
- Real-time price updates
- Search functionality
- Error handling for network issues and API failures
- Unit and widget tests

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE (e.g., Android Studio, VS Code)
- Finnhub API key

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/farisk218/flutter_trading_app.git
   ```

2. Navigate to the project directory:
   ```
   cd flutter-trading-instruments
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Running Tests

To run all tests:
```
flutter test
```

## Architecture

This project follows Clean Architecture principles and uses Test-Driven Development (TDD). It's structured into the following layers:

- Presentation
- Domain
- Data

The app uses BLoC for state management and dependency injection for better testability and maintainability.

## Libraries Used

- flutter_bloc: For state management
- bloc_concurrency: For handling concurrent events in BLoC
- dio: For making HTTP requests
- get_it: For dependency injection
- google_fonts: For custom fonts
- flutter_screenutil: For responsive UI
- equatable: For value equality
- pull_to_refresh: For implementing pull-to-refresh functionality
- flutter_easyloading: For loading indicators
- auto_size_text: For automatically resizing text
- fluro: For navigation

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
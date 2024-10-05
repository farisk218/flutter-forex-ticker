# Flutter Forex real-time price ticker App

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
   ```bash
   git clone https://github.com/farisk218/flutter_trading_app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd flutter-trading-instruments
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Set up the Finnhub API key for development:
   - Add your **Finnhub API Key** using the `--dart-define` argument:
     ```bash
     flutter run --dart-define=FINNHUB_API_KEY=your_api_key_here
     ```

## Building the Release APK with Obfuscation

### APK Build Process

To create a **release APK** with **obfuscation** and **R8 (ProGuard)** enabled:

1. Open the `android/app/build.gradle` file.
2. Ensure that ProGuard and resource shrinking are enabled in the `release` build type:
   ```gradle
   buildTypes {
       release {
           minifyEnabled true
           shrinkResources true
           proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
       }
   }
   ```
3. Build the APK with obfuscation and provide the **Finnhub API Key**:
   ```bash
   flutter build apk --release --dart-define=FINNHUB_API_KEY=your_production_key_here --obfuscate --split-debug-info=/<path-to-store-debug-info>
   ```

   Here, `/<path-to-store-debug-info>` is the directory where the debug symbols are stored, which allows you to de-obfuscate stack traces later if needed.

4. The APK can be found in the `build/app/outputs/flutter-apk/` directory.

### Environment Variables for API Key

To securely pass the **Finnhub API Key** during the build process, use `--dart-define` like this:
```bash
flutter build apk --release --dart-define=FINNHUB_API_KEY=your_production_key_here
```

Make sure to replace `your_production_key_here` with your actual production API key.

## Running Tests

To run all tests:
```bash
flutter test
```

## Architecture

This project follows Clean Architecture principles and uses Test-Driven Development (TDD). It's structured into the following layers:

- **Presentation**
- **Domain**
- **Data**

The app uses **BLoC** for state management and **dependency injection** to enhance testability and maintainability.

## Libraries Used

- `flutter_bloc`: For state management
- `bloc_concurrency`: For handling concurrent events in BLoC
- `dio`: For making HTTP requests
- `get_it`: For dependency injection
- `google_fonts`: For custom fonts
- `flutter_screenutil`: For responsive UI
- `equatable`: For value equality
- `pull_to_refresh`: For implementing pull-to-refresh functionality
- `fluro`: For navigation
- `web_socket_channel`: For managing WebSocket connections
- `shared_preferences`: For storing simple app data locally
- `internet_connection_checker`: For checking internet connectivity
- `dartz`: For functional programming constructs
- `rxdart`: For reactive programming with streams
- `flutter_launcher_icons`: For customizing app launcher icons
- `flutter_svg`: For rendering SVG images
- `scrollable_positioned_list`: For efficient list rendering with position tracking
- `flutter_dotenv`: For managing environment variables
- `flutter_spinkit`: For displaying loading animations

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

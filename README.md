# Bible Journey

Welcome to **Bible Journey**, a free, open-source app by 
[Pilgrim's Journey](https://github.com/PilgrimsJourney) to guide Christians through Bible
reading plans. This app helps you follow structured plans, track progress, and
deepen your spiritual journey, with no ads or unnecessary costs.

## Purpose

**Pilgrim's Journey** creates tools to support Christians in their walk with
God. **Bible Journey** is our first step, offering a simple, distraction-free
way to engage with Scripture through customizable reading plans. Our mission is
to provide free, open-source resources to aid believers on their journey. We
invite contributions from developers, designers, and believers to make this
tool a blessing for all.

## Getting Started

Follow these steps to run or test **Bible Journey** locally.

### Prerequisites

- **Flutter**: The app is built with Flutter. Install Flutter by following the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).
- **Dart**: Included with Flutter, but ensure you have a compatible version (see `pubspec.yaml` for requirements).
- **Device/Emulator**: A physical device (iOS/Android) or emulator/simulator for testing.

### Installation

1. **Clone the Repository**:
   ```
   git clone https://github.com/PilgrimsJourney/BibleJourney.git
   cd BibleJourney
   ```

2. **Install Dependencies**:
   Run the following to fetch Flutter packages:
   ```
   flutter pub get
   ```

3. **Set Up Hive**:
   The app uses [Hive](https://pub.dev/packages/hive) for local persistence. No additional setup is needed beyond the dependencies in `pubspec.yaml`, as Hive is initialized in `main.dart`.

4. **Run the App**:
   - Ensure a device or emulator is connected.
   - Run the app in debug mode:
     ```
     flutter run
     ```
   - For web development (e.g., testing on a browser):
     ```
     flutter run -d web-server --web-hostname=localhost --web-port=8080
     ```

### Testing

To ensure the app works as expected, run the unit and widget tests included in the `test/` directory.

1. **Run Tests**:
   ```
   flutter test
   ```
   This executes all tests (e.g., `test/models/reading_plan_test.dart`, `test/models/user_test.dart`).

2. **Test Coverage**:
   To generate a coverage report:
   ```
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   ```
   Open `coverage/html/index.html` in a browser to view coverage.

3. **Writing Tests**:
   - Tests are located in the `test/` directory.
   - Use the `flutter_test` package for unit and widget tests.
   - Example: Add tests for new features in `test/models/` or `test/views/`.

### Project Structure

- `lib/models/`: Data models (e.g., `reading_plan.dart`, `user.dart`).
- `lib/views/`: UI screens (e.g., `reading_plan_selector.dart`).
- `lib/adapters/`: Hive adapters and persistence logic (e.g., `hive_adapters.dart`, `user_storage_adapter.dart`).
- `test/`: Unit and widget tests.
- `pubspec.yaml`: Dependencies and app configuration.

### Contributing

We welcome contributions to **Bible Journey**! Whether you’re a developer, designer, or Christian with ideas, your time and skills can help others grow in faith. To contribute:

1. Fork the repository and create a branch for your feature or fix.
2. Submit a pull request with clear descriptions of your changes.
3. Join the discussion in [GitHub Issues](https://github.com/PilgrimsJourney/BibleJourney/issues) to suggest features or report bugs.

### Funding

**Bible Journey** is free and open-source, with no ads. To support development, consider
<!-- sponsoring us via [GitHub Sponsors](https://github.com/sponsors/PilgrimsJourney) or -->
contributing code.

### Contact

For questions or feedback, open an issue on GitHub or reach out via [Pilgrim's Journey](https://pilgrimsjourney.app) (coming soon).

---

**Join us on this journey to bring Christians closer to God through Scripture!**

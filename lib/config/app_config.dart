abstract class AppConfig {
  static const bool isTestMode = bool.fromEnvironment('IS_TEST_MODE', defaultValue: false);
}
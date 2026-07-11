/// Central registry for every image / asset path used in the app.
///
/// Never hardcode asset strings in widgets — add them here first.
///
/// Example:
/// ```dart
/// Image.asset(ImagePath.placeholderLogo);
/// ```
abstract final class ImagePath {
  /// Placeholder brand mark (optional future asset).
  static const String placeholderLogo = 'assets/images/.gitkeep';
}

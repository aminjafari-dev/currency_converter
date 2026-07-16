/// Central registry of asset image paths for Nerkhak.
///
/// Always reference images through this class instead of hardcoding strings.
/// Add every new asset path here before using it in widgets.
///
/// Example:
/// ```dart
/// Image.asset(ImagePath.logo, width: 32, height: 32);
/// ```
abstract final class ImagePath {
  /// Brand mark — lime geometric “N” on charcoal (app icon + in-UI logo).
  static const String logo = 'assets/images/logo.jpeg';
}

import 'dart:io';

/// Script to inject Google Maps API key into web/index.html during build
void main() {
  // Read the API key from environment variable (set by shell script)
  final apiKey = Platform.environment['GOOGLE_MAPS_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Error: GOOGLE_MAPS_API_KEY not found in environment');
    print('Make sure the .env file exists and contains the API key');
    exit(1);
  }

  // Read index.html
  final indexFile = File('web/index.html');
  if (!indexFile.existsSync()) {
    print('Error: web/index.html not found');
    exit(1);
  }

  var content = indexFile.readAsStringSync();

  // Replace the placeholder script tag with actual Google Maps script
  final googleMapsScript =
      '<script src="https://maps.googleapis.com/maps/api/js?key=$apiKey"></script>';
  content = content.replaceAll(
    '<script id="google-maps-script"></script>',
    googleMapsScript,
  );

  // Write back to index.html
  indexFile.writeAsStringSync(content);

  print('✓ Injected Google Maps API key into web/index.html');
}

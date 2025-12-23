import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MarkerGenerator {
  static const double _imageSize = 80.0;

  /// Creates a circular image marker.
  static Future<BitmapDescriptor> createCircularImageMarker(
    String imageUrl,
  ) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = Colors.white;

    // Dimensions
    const double size = _imageSize;
    // Square canvas since we removed the pointer
    const double totalHeight = size;

    // Draw white border circle
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    // Draw Image
    try {
      final ui.Image? propertyImage = await _loadImageFromUrl(imageUrl);
      if (propertyImage != null) {
        final Rect src = Rect.fromLTWH(
          0,
          0,
          propertyImage.width.toDouble(),
          propertyImage.height.toDouble(),
        );
        final Rect dst = Rect.fromLTWH(
          2, // Padding for border
          2,
          size - 4,
          size - 4,
        );

        // Draw rounded image
        final Path clipPath = Path()
          ..addOval(Rect.fromLTWH(2, 2, size - 4, size - 4));
        canvas.save();
        canvas.clipPath(clipPath);
        canvas.drawImageRect(propertyImage, src, dst, Paint());
        canvas.restore();
      }
    } catch (e) {
      debugPrint('Error loading image for marker: $e');
    }

    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      totalHeight.toInt(),
    );
    final ByteData? byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  static Future<ui.Image?> _loadImageFromUrl(String url) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Completer<ui.Image> completer = Completer();
        ui.decodeImageFromList(response.bodyBytes, (ui.Image img) {
          completer.complete(img);
        });
        return completer.future;
      }
    } catch (e) {
      debugPrint('Failed to load marker image: $e');
    }
    return null;
  }
}

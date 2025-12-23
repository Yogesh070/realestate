import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MarkerGenerator {
  static const double _markerWidth = 70.0;
  static const double _markerHeight = 35.0;
  static const double _imageSize = 80.0;
  static const double _pointerHeight = 10.0;

  /// Creates a marker with just the price bubble.
  static Future<BitmapDescriptor> createPriceMarker(String price) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.black;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    const double radius = 12.0;
    const double totalHeight = _markerHeight + _pointerHeight;

    // Draw background bubble with pointer
    final Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, _markerWidth, _markerHeight),
        const Radius.circular(radius),
      ),
    );
    path.moveTo(_markerWidth / 2 - 6, _markerHeight);
    path.lineTo(_markerWidth / 2, totalHeight);
    path.lineTo(_markerWidth / 2 + 6, _markerHeight);
    path.close();

    canvas.drawPath(path, paint);

    // Draw Price Text
    textPainter.text = TextSpan(
      text: '\$$price',
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (_markerWidth - textPainter.width) / 2,
        (_markerHeight - textPainter.height) / 2,
      ),
    );

    // Convert to image
    final ui.Image image = await pictureRecorder.endRecording().toImage(
      _markerWidth.toInt(),
      totalHeight.toInt(),
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  /// Creates a marker with price bubble and an image above it.
  static Future<BitmapDescriptor> createPriceImageMarker(
    String price,
    String imageUrl,
  ) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.black;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Dimensions
    const double totalHeight = _markerHeight + _imageSize + 10 + _pointerHeight;
    const double totalWidth = _markerWidth > _imageSize
        ? _markerWidth
        : _imageSize;

    final double bubbleTop = totalHeight - _markerHeight - _pointerHeight;

    // Draw Price Bubble at the bottom with pointer
    final Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (totalWidth - _markerWidth) / 2,
          bubbleTop,
          _markerWidth,
          _markerHeight,
        ),
        const Radius.circular(12.0),
      ),
    );
    // Pointer
    path.moveTo(totalWidth / 2 - 6, bubbleTop + _markerHeight);
    path.lineTo(totalWidth / 2, totalHeight);
    path.lineTo(totalWidth / 2 + 6, bubbleTop + _markerHeight);
    path.close();

    canvas.drawPath(path, paint);

    textPainter.text = TextSpan(
      text: '\$$price',
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (totalWidth - textPainter.width) / 2,
        bubbleTop + (_markerHeight - textPainter.height) / 2,
      ),
    );

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
          (totalWidth - _imageSize) / 2,
          0,
          _imageSize,
          _imageSize,
        );

        // Draw rounded image
        final Path clipPath = Path()
          ..addRRect(RRect.fromRectAndRadius(dst, const Radius.circular(8.0)));
        canvas.save();
        canvas.clipPath(clipPath);
        canvas.drawImageRect(propertyImage, src, dst, Paint());
        canvas.restore();
      }
    } catch (e) {
      debugPrint('Error loading image for marker: $e');
    }

    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      totalWidth.toInt(),
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

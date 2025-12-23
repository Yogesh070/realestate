import 'package:google_maps_flutter/google_maps_flutter.dart';

class Property {
  final String id;
  final String name;
  final LatLng location;
  final double price;
  final double area; // in square feet
  final String description;
  final String imageUrl;

  const Property({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.area,
    required this.description,
    required this.imageUrl,
  });
}

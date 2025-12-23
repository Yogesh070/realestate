import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/property.dart';

final List<Property> dummyProperties = [
  Property(
    id: '1',
    name: 'Sunset Valley Land',
    location: const LatLng(37.7749, -122.4194), // San Francisco
    price: 500000,
    area: 5000,
    description:
        'Beautiful land with a sunset view suitable for residential building.',
    imageUrl:
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '2',
    name: 'Green Meadows',
    location: const LatLng(37.7849, -122.4294),
    price: 750000,
    area: 8000,
    description: 'Expansive green meadows perfect for farming or large estate.',
    imageUrl:
        'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '3',
    name: 'Hilltop Plot',
    location: const LatLng(37.7649, -122.4094),
    price: 600000,
    area: 4500,
    description: 'Prime hilltop location with panoramic city views.',
    imageUrl:
        'https://images.unsplash.com/photo-1513883049090-d0b7439799bf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '4',
    name: 'Lakeside Acre',
    location: const LatLng(37.7549, -122.4394),
    price: 900000,
    area: 12000,
    description: 'Premium lakeside property with private access.',
    imageUrl:
        'https://images.unsplash.com/photo-1505537546736-21800c888d36?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '5',
    name: 'Downtown Commercial Lot',
    location: const LatLng(37.7949, -122.3994),
    price: 2500000,
    area: 3000,
    description:
        'Rare empty lot in the heart of downtown, zoned for commercial use.',
    imageUrl:
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
];

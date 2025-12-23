import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/property.dart';

final List<Property> dummyProperties = [
  Property(
    id: '1',
    name: 'Lakeside Premium Land',
    location: const LatLng(28.2095, 83.9585), // Pokhara Lakeside
    price: 15000000,
    area: 2500,
    description:
        'Prime commercial land located in the heart of Lakeside, Pokhara. Perfect for hotel or restaurant.',
    imageUrl:
        'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '2',
    name: 'Sarangkot View Plot',
    location: const LatLng(28.2439, 83.9486),
    price: 8500000,
    area: 5000,
    description:
        'Beautiful residential plot with panoramic views of the Annapurna range and Fewa Lake.',
    imageUrl:
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '3',
    name: 'Pame Lakeside Acre',
    location: const LatLng(28.2238, 83.9314),
    price: 12000000,
    area: 15000,
    description:
        'Expansive land in Pame, ideal for a resort or organic farm with lake access.',
    imageUrl:
        'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '4',
    name: 'Hemja Residential Lot',
    location: const LatLng(28.2612, 83.9392),
    price: 4500000,
    area: 3200,
    description:
        'Peaceful residential lot in Hemja with easy access to the highway and mountain views.',
    imageUrl:
        'https://images.unsplash.com/photo-1513883049090-d0b7439799bf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '5',
    name: 'Matepani Commercial Space',
    location: const LatLng(28.2163, 83.9961),
    price: 9500000,
    area: 2800,
    description:
        'Commercial land in Matepani area, suitable for business or residential apartments.',
    imageUrl:
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '6',
    name: 'Lakeside Boutique Site',
    location: const LatLng(28.2110, 83.9590),
    price: 18000000,
    area: 1800,
    description:
        'Excellent spot for a boutique shop or cafe right in the main street of Lakeside.',
    imageUrl:
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '7',
    name: 'Baidam Quiet Alley Lot',
    location: const LatLng(28.2080, 83.9610),
    price: 7000000,
    area: 2500,
    description:
        'A peaceful residential lot tucked away in the alleys of Baidam, yet close to the lake.',
    imageUrl:
        'https://images.unsplash.com/photo-1524813685584-c3bb98c76214?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '8',
    name: 'Khapaudi Waterfront',
    location: const LatLng(28.2220, 83.9450),
    price: 25000000,
    area: 10000,
    description:
        'Spectacular waterfront property in Khapaudi, perfect for a high-end luxury resort.',
    imageUrl:
        'https://images.unsplash.com/photo-1505537546736-21800c888d36?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '9',
    name: 'Zero KM Highway Plot',
    location: const LatLng(28.2200, 83.9750),
    price: 11000000,
    area: 2200,
    description:
        'Strategic commercial plot at Zero KM, Pokhara with high visibility.',
    imageUrl:
        'https://images.unsplash.com/photo-1541447271487-09612b3f49f7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  Property(
    id: '10',
    name: 'Parsyang Housing Site',
    location: const LatLng(28.2250, 83.9720),
    price: 5500000,
    area: 3000,
    description:
        'Affordable housing lot in the growing neighborhood of Parsyang.',
    imageUrl:
        'https://images.unsplash.com/photo-1493666438817-866a91353ca9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
];

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import '../models/property.dart';
import '../data/dummy_data.dart';
import '../utils/marker_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'filter_screen.dart';

class RealEstateMap extends StatefulWidget {
  const RealEstateMap({super.key});

  @override
  State<RealEstateMap> createState() => _RealEstateMapState();
}

class _RealEstateMapState extends State<RealEstateMap> {
  final Set<Marker> _markers = {};
  bool _showImages = false;
  late RangeValues _priceRange;
  late double _minPrice;
  late double _maxPrice;
  late RangeValues _areaRange;
  late double _minArea;
  late double _maxArea;

  // Initial position focused on Pokhara, Nepal
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.2095, 83.9585),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    // Calculate min and max pricesand area from data
    double minP = double.infinity;
    double maxP = double.negativeInfinity;
    double minA = double.infinity;
    double maxA = double.negativeInfinity;

    for (var p in dummyProperties) {
      if (p.price < minP) minP = p.price;
      if (p.price > maxP) maxP = p.price;
      if (p.area < minA) minA = p.area;
      if (p.area > maxA) maxA = p.area;
    }
    _minPrice = minP;
    _maxPrice = maxP;
    _priceRange = RangeValues(_minPrice, _maxPrice);

    _minArea = minA;
    _maxArea = maxA;
    _areaRange = RangeValues(_minArea, _maxArea);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
    });
  }

  Future<void> _loadMarkers() async {
    if (!mounted) return;
    final Color primaryColor = Theme.of(context).primaryColor;

    // Create a temporary set to avoid flickering (Double Buffering)
    final Set<Marker> tempMarkers = {};
    final List<Future<void>> loadingTasks = [];

    for (final property in dummyProperties) {
      if (property.price < _priceRange.start ||
          property.price > _priceRange.end) {
        continue;
      }
      if (property.area < _areaRange.start || property.area > _areaRange.end) {
        continue;
      }

      final String shortPrice =
          '${(property.price / 1000).toStringAsFixed(0)}k';

      // 1. Add Image Marker (Standard Google Maps Marker) - Only if zoomed in
      if (_showImages) {
        loadingTasks.add(
          MarkerGenerator.createCircularImageMarker(property.imageUrl)
              .then((icon) {
                tempMarkers.add(
                  Marker(
                    markerId: MarkerId('${property.id}_image'),
                    position: property.location,
                    icon: icon,
                    // Anchor at (0.5, 1.5) to bring image closer to the label.
                    // 1.0 is bottom-aligned. 1.5 shifts it up slightly to sit just above the label.
                    anchor: const Offset(0.5, 1.5),
                    zIndexInt: 2, // Ensure image is above label
                    onTap: () {
                      _showPropertyDetails(property);
                    },
                  ),
                );
              })
              .catchError((e) {
                debugPrint('Error loading image marker: $e');
              }),
        );
      }

      loadingTasks.add(
        tempMarkers.addLabelMarker(
          LabelMarker(
            label: shortPrice,
            markerId: MarkerId(property.id),
            position: property.location,
            backgroundColor: primaryColor,
            textStyle: const TextStyle(
              fontSize: 40.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              _showPropertyDetails(property);
            },
          ),
        ),
      );
    }

    await Future.wait(loadingTasks);
    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.addAll(tempMarkers);
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (position.zoom >= 15 && !_showImages) {
      setState(() {
        _showImages = true;
      });
      _loadMarkers();
    } else if (position.zoom < 15 && _showImages) {
      setState(() {
        _showImages = false;
      });
      _loadMarkers();
    }
  }

  void _showPropertyDetails(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PropertyDetailsSheet(property: property);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push<FilterScreenResult>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterScreen(
                      currentPriceRange: _priceRange,
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                      currentAreaRange: _areaRange,
                      minArea: _minArea,
                      maxArea: _maxArea,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _priceRange = result.priceRange;
                    _areaRange = result.areaRange;
                  });
                  _loadMarkers();
                }
              },
            ),
          ),
          // Price Filter Chip
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_priceRange.start > _minPrice ||
                    _priceRange.end < _maxPrice) ...[
                  Chip(
                    label: Text(
                      '\$${(_priceRange.start / 1000).toStringAsFixed(0)}k - \$${(_priceRange.end / 1000).toStringAsFixed(0)}k',
                    ),
                    backgroundColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        _priceRange = RangeValues(_minPrice, _maxPrice);
                      });
                      _loadMarkers();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
                if (_areaRange.start > _minArea || _areaRange.end < _maxArea)
                  Chip(
                    label: Text(
                      '${_areaRange.start.toStringAsFixed(0)} - ${_areaRange.end.toStringAsFixed(0)} sq ft',
                    ),
                    backgroundColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        _areaRange = RangeValues(_minArea, _maxArea);
                      });
                      _loadMarkers();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetailsSheet extends StatelessWidget {
  final Property property;

  const PropertyDetailsSheet({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return _PropertyDetailsContent(
          property: property,
          scrollController: scrollController,
        );
      },
    );
  }
}

class _PropertyDetailsContent extends StatelessWidget {
  final Property property;
  final ScrollController scrollController;

  const _PropertyDetailsContent({
    required this.property,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: CachedNetworkImage(
              imageUrl: property.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[300],
                alignment: Alignment.center,
              ),
              errorWidget: (context, url, error) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '\$${property.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.square_foot, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${property.area.toStringAsFixed(0)} sq ft',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Placeholder for contact functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact feature not implemented yet'),
                        ),
                      );
                    },
                    child: const Text('Contact Agent'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

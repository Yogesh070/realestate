import 'package:flutter/material.dart';

class FilterScreenResult {
  final RangeValues priceRange;
  final RangeValues areaRange;

  FilterScreenResult({required this.priceRange, required this.areaRange});
}

class FilterScreen extends StatefulWidget {
  final RangeValues currentPriceRange;
  final double minPrice;
  final double maxPrice;
  final RangeValues currentAreaRange;
  final double minArea;
  final double maxArea;

  const FilterScreen({
    super.key,
    required this.currentPriceRange,
    required this.minPrice,
    required this.maxPrice,
    required this.currentAreaRange,
    required this.minArea,
    required this.maxArea,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late RangeValues _currentPriceRange;
  late RangeValues _currentAreaRange;

  @override
  void initState() {
    super.initState();
    _currentPriceRange = widget.currentPriceRange;
    _currentAreaRange = widget.currentAreaRange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Properties')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${(_currentPriceRange.start / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '\$${(_currentPriceRange.end / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            RangeSlider(
              values: _currentPriceRange,
              min: widget.minPrice,
              max: widget.maxPrice,
              divisions: 100,
              labels: RangeLabels(
                '\$${(_currentPriceRange.start / 1000).toStringAsFixed(0)}k',
                '\$${(_currentPriceRange.end / 1000).toStringAsFixed(0)}k',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentPriceRange = values;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Area Range (sq ft)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentAreaRange.start.toStringAsFixed(0)} sq ft',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '${_currentAreaRange.end.toStringAsFixed(0)} sq ft',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            RangeSlider(
              values: _currentAreaRange,
              min: widget.minArea,
              max: widget.maxArea,
              divisions: 100,
              labels: RangeLabels(
                '${_currentAreaRange.start.toStringAsFixed(0)} sq ft',
                '${_currentAreaRange.end.toStringAsFixed(0)} sq ft',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentAreaRange = values;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    FilterScreenResult(
                      priceRange: _currentPriceRange,
                      areaRange: _currentAreaRange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Apply Filter',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

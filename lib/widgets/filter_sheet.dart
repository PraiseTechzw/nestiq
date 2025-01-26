import 'package:flutter/material.dart';
import 'package:nestiq/models/property.dart';

class FilterSheet extends StatefulWidget {
  final PropertyType? selectedType;
  final double minPrice;
  final double maxPrice;
  final String? selectedLocation;
  final Function(PropertyType?, double, double, String?) onApply;

  const FilterSheet({
    Key? key,
    this.selectedType,
    required this.minPrice,
    required this.maxPrice,
    this.selectedLocation,
    required this.onApply,
  }) : super(key: key);

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late PropertyType? _selectedType;
  late RangeValues _priceRange;
  late String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _priceRange = RangeValues(widget.minPrice, widget.maxPrice);
    _selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedType = null;
                    _priceRange = const RangeValues(0, 5000);
                    _selectedLocation = null;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Property Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: PropertyType.values.map((type) {
              return ChoiceChip(
                label: Text(type.toString().split('.').last),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? type : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Price Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 5000,
            divisions: 50,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select location',
            ),
            items: const [
              DropdownMenuItem(
                value: 'north',
                child: Text('North'),
              ),
              DropdownMenuItem(
                value: 'south',
                child: Text('South'),
              ),
              DropdownMenuItem(
                value: 'east',
                child: Text('East'),
              ),
              DropdownMenuItem(
                value: 'west',
                child: Text('West'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.onApply(
                _selectedType,
                _priceRange.start,
                _priceRange.end,
                _selectedLocation,
              );
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}


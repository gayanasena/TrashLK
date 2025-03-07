import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged; // For search bar text changes
  final List<String> availableFilters;
  final Function(List<String>) onFiltersChanged; // Callback for filters

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    required this.availableFilters,
    required this.onFiltersChanged,
  });

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  List<String> selectedFilters = [];

  void showFilterPopup(BuildContext context) async {
    final List<String>? newFilters = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          selectedFilters: selectedFilters,
          availableFilters: widget.availableFilters,
        );
      },
    );

    if (newFilters != null) {
      setState(() {
        selectedFilters = newFilters;
      });
      // Notify parent widget of the new selected filters
      widget.onFiltersChanged(selectedFilters);
    }
  }

  void clearFilters() {
    setState(() {
      selectedFilters.clear();
    });
    // Notify parent widget of cleared filters
    widget.onFiltersChanged(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged, // Search text changed event
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () => showFilterPopup(context),
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ),
        ),
        if (selectedFilters.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ...selectedFilters.map((filter) => Chip(
                      label: Text(filter),
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onDeleted: () {
                        setState(() {
                          selectedFilters.remove(filter);
                        });
                        widget.onFiltersChanged(
                            selectedFilters); // Update parent on filter deletion
                      },
                    )),
                ActionChip(
                  label: const Text('Clear Filters'),
                  onPressed: clearFilters,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class FilterDialog extends StatefulWidget {
  final List<String> selectedFilters;
  final List<String> availableFilters;

  const FilterDialog(
      {super.key,
      required this.selectedFilters,
      required this.availableFilters});

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  late List<String> tempSelectedFilters;

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = List.from(widget.selectedFilters);
  }

  void toggleFilter(String filter) {
    setState(() {
      if (tempSelectedFilters.contains(filter)) {
        tempSelectedFilters.remove(filter);
      } else {
        tempSelectedFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Filters'),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8.0,
          children: widget.availableFilters.map((filter) {
            return FilterChip(
              label: Text(filter),
              selected: tempSelectedFilters.contains(filter),
              onSelected: (_) => toggleFilter(filter),
              backgroundColor: Colors.grey[300], // Gray color without a border
              selectedColor:
                  Colors.blue[400], // Optional selected color for better UX
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Fully rounded
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.selectedFilters),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(tempSelectedFilters),
          child: const Text(
            'Apply',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

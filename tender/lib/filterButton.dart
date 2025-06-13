import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:tender/menu_items.dart';

//button for overall filters
class FiltersButton extends StatelessWidget {
  final VoidCallback onTapFilter;

  const FiltersButton({super.key, required this.onTapFilter});

  // Draw a button that opens the filters menu
  @override
  Widget build(BuildContext context) {
    // Spacing to prevent menu from being cutoff by side of screen
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        // Open the filters menu when interacted with
        onTap: () {
          //onTapFilter();
          showPopover(
            context: context,
            bodyBuilder: (context) => MenuItems(onFiltersApplied: onTapFilter,),
            width: 200,
            height: 350,
            backgroundColor: Colors.pink.shade100,
            direction: PopoverDirection.bottom,
          );
        },
        // User sees a filters symbol as the button icon
        child: const Icon(Icons.filter_list_rounded, size:35),
      )
    );
  }
}
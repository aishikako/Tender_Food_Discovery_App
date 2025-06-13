import 'package:flutter/material.dart';
import 'package:tender/filterSwitches.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({super.key, required this.onFiltersApplied});
  final VoidCallback onFiltersApplied;


  static TextStyle optionStyle = TextStyle(fontSize: 20, color: Colors.black);

  // Draw filters menu with 7 options - each option with a label and a toggleable switch
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1st menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[700],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(child: Text('Eggless', style: optionStyle)),
                FilterSwitch(name: 'Eggless', onTapFilter: onFiltersApplied)
              ]
            )
          )
        ),
        // 2nd menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[600],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Vegetarian', style: optionStyle)), FilterSwitch(name: 'Vegetarian', onTapFilter: onFiltersApplied)]),
          )
        ),
        // 3rd menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[500],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Vegan', style: optionStyle)), FilterSwitch(name: 'Vegan', onTapFilter: onFiltersApplied)]),
          )
        ),
        // 4th menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[400],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Dairy-Free', style: optionStyle)), FilterSwitch(name: 'Dairy free', onTapFilter: onFiltersApplied)]),
          )
        ),
        // 5th menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Gluten-Free', style: optionStyle)), FilterSwitch(name: 'Gluten free', onTapFilter: onFiltersApplied)]),
          )
        ),
        // 6th menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Seafood', style: optionStyle)), FilterSwitch(name: 'Seafood', onTapFilter: onFiltersApplied)]),
          )
        ),
        // 7th menu option
        Container(
          height:50,
          width: double.infinity,
          color:Colors.pink[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(children: [Expanded(child: Text('Dessert', style: optionStyle)), FilterSwitch(name: 'Dessert', onTapFilter: onFiltersApplied)]),
          )
        ),
      ],
    );
  }
}
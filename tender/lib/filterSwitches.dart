import 'package:flutter/material.dart';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FilterSwitch extends StatefulWidget {
  final VoidCallback onTapFilter;
  final String name;

  const FilterSwitch({required this.name, super.key, required this.onTapFilter});

  @override
  State<FilterSwitch> createState() => _FilterSwitchState(name: name);
}
// Find out if the user has turned a filter on or off and return its state
class _FilterSwitchState extends State<FilterSwitch> {
  final String name;
  String? user;

  _FilterSwitchState({required this.name});

  Future<bool> setFilterIDs() async {
    user = FirebaseAuth.instance.currentUser?.uid;
    try {
      final docSnapshot = await firestore
          .collection('users')
          .doc(user)
          .get();

      final data = docSnapshot.data();
      final filters = data?['filters'] as Map<String, dynamic>?;

      final filterState = filters?['${name}'] as bool?;

      return filterState ?? false; // fallback to false if null
    } catch (error) {
      print("Error fetching recipe IDs: $error");
      return false; // fallback to false on error
    }
  }

  // Draw the switch in the correct state (on/off based on user settings)
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: setFilterIDs(), // What to show once loaded
      builder: (context, snapshot) {  // Draw Widget
        if (snapshot.connectionState == ConnectionState.waiting) {  // What to draw if still waiting on data loading
          return const CircularProgressIndicator(); // Show loading indicator while fetching
        } else if (snapshot.hasError) { // Report Loading Errors
          print("Error in FutureBuilder: ${snapshot.error}");
          return const Switch(value: false, onChanged: null); // Disabled switch on error
        } else {  // Once data has been loaded, use it to draw widget

          // Use fetched value or default to false
          bool light = snapshot.data ?? false;

          // Draw the switch with the fetched value state 
          return Switch(
            value: light,
            activeColor: Colors.black,
            onChanged: (bool value) async {
              setState(() {
                light = value;
              });
              await firestore
                  .collection('users')
                  .doc(user)
                  .update({
                'filters.${name}': light,
              });
              widget.onTapFilter();
            },
          );
        }
      },
    );
  }
}
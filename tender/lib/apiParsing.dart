/* import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Fetches and uploads recipes for each letter of the alphabet (a-z)
Future<void> fetchAllMealsAtoZ() async {
  // Loop through each letter from A - Z
  for (var letterCode = 'a'.codeUnitAt(0); letterCode <= 'z'.codeUnitAt(0); letterCode++) {
    final letter = String.fromCharCode(letterCode);

    // Construct the URL to fetch meals starting with the current letter
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$letter');

    // Send the GET request to the API
    final response = await http.get(url);

    // If request fails, skip to the next letter
    if (response.statusCode != 200) {
      print('Failed to fetch meals for letter "$letter"');
      continue;
    }

    // Decode the JSON response into a Dart object
    final data = json.decode(response.body);
    final meals = data['meals'];

    // If no meals were returned for this letter, skip
    if (meals == null) continue;

    // Loop through each meal in the list
    for (final meal in meals) {
      // Extract the title (name of the meal)
      final title = meal['strMeal'] ?? 'Untitled';

      // Extract the image URL
      final imageUrl = meal['strMealThumb'] ?? '';

      // Create a basic description using area and category
      final description = 'A delicious ${meal['strArea']} ${meal['strCategory']} dish.';

      // Build the ingredients list by combining ingredient and measure pairs
      final ingredients = <String>[];
      for (int i = 1; i <= 20; i++) {
        final ingredient = meal['strIngredient$i'];
        final measure = meal['strMeasure$i'];

        // Only include non-empty values
        if (ingredient != null &&
            ingredient.toString().trim().isNotEmpty &&
            measure != null &&
            measure.toString().trim().isNotEmpty) {
          ingredients.add('${measure.trim()} ${ingredient.trim()}');
        }
      }

      // Break the instructions string into a list of steps
      final instructions = meal['strInstructions'] ?? '';
      final procedure = instructions
          .split(RegExp(r'\.\s+')) // Split at period + space (end of sentence)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Convert tags into a list if they exist, else empty list
      final tags = meal['strTags']?.split(',') ?? [];

      // Default values for fields not provided by the API
      final servings = 2;
      final time = 30;

      // Build the final recipe document to match your Firestore schema
      final recipe = {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'procedure': procedure,
        'servings': servings,
        'time': time,
        'tags': tags,
      };

      // Upload the recipe to Firestore under the "recipes" collection
      await FirebaseFirestore.instance.collection('recipes').add(recipe);
      print('Uploaded: $title');
    }
  }

  // After all letters have been processed
  print('Finished uploading all meals from A to Z');
}
*/
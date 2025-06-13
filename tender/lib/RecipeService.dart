import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  // Extract direct image URL from Google link
  static String extractDirectImageUrl(String googleLink) {
    final decoded = Uri.decodeFull(googleLink);
    final start = decoded.indexOf('imgurl=') + 7;
    final end = decoded.indexOf('&', start);
    if (start == -1 || end == -1) return '';
    return decoded.substring(start, end);
  }

  // Add imageUrl to Firestore
  static Future<void> addImageUrlToRecipe(String recipeId, String imageUrl) async {
    final docRef = FirebaseFirestore.instance.collection('recipes').doc(recipeId);
    await docRef.set({'imageUrl': imageUrl}, SetOptions(merge: true));
    print('Added imageUrl to recipe $recipeId');
  }

  // Combine both steps
  static Future<void> extractAndAddImageUrl(String recipeId, String googleLink) async {
    final directUrl = extractDirectImageUrl(googleLink);
    print("Extracted URL: $directUrl");
    if (directUrl.isNotEmpty) {
      await addImageUrlToRecipe(recipeId, directUrl);
    } else {
      print('Failed to extract image URL from Google link.');
    }
  }
}

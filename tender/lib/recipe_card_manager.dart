
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tender/main.dart';
import 'package:tender/recipe_card.dart';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

//manages getting data from firebase to recipe cards
class RecipeCardManager {
    static late List<String> recipeIds;
    static List<dynamic> dislikedRecipeIds = [];
    static List<dynamic> savedRecipeIds = [];
    static List<RecipeCard> recipeCards = [];
    static List<String> activatedFilters = <String>[];

    static Future<void> createRecipeCards() async{
      await getRecipeIds();
      await getRecipeLists();
      
      for (int i = 0; i < (recipeIds.length); i++) {
          RecipeCard testing = RecipeCard(recipeId: recipeIds[i]);
          await testing.parseData();
          recipeCards.add(testing);
      }
    }

  static Future<void> getRecipeIds() async{
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection("recipes").get();
      recipeIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (error) {
      print("Error fetching recipe IDs: $error");
    }
  }

//updates the disliked and saved recipe ids in this class
  static Future<void> getRecipeLists() async{
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      dislikedRecipeIds = userDoc.data()?['disliked_recipes'] ?? [];
      savedRecipeIds = userDoc.data()?['saved_recipes'] ?? [];

      
    } catch (e) {
      print("Error checking disliked recipe: $e");
    }
  }

  static Future<void> getFilters() async{
    try {
      // Access filter state data from firebase
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      
      final data = userDoc.data();
      final filters = data?['filters'] as Map<String, dynamic>?;

      // Get only active filters
      if (filters != null) {
        filters.forEach((key, value) {
          if(value == true) {
            if(!activatedFilters.contains(key)) activatedFilters.add(key);
          }
          else{
            activatedFilters.remove(key);
          }
        });
      }
    } catch(e) {
      print("Error accessing filter: $e");
    }
  }

  static displayIds(){
    print(recipeIds[0]);
  }

}
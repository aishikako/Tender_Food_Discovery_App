
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart';


class RecipeCard {
  late String title;
  late String title_short;
  late String description;
  late int prepTime;

  late int servingSize;
  late List<dynamic> tags;
  late List<dynamic> ingredients;
  late List<dynamic> procedure;
  final String recipeId;
  late String imageUrl;

  RecipeCard({required this.recipeId});

  // going through the given documenting, and saving each field using firebase data
  Future<void> parseData() async {
    try {
      // getting a snapshot of a given collection, using the document id
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection("recipes").doc(recipeId).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();

        // accessing all the field within the database and setting the fields
        if (data != null) {
          title = data['Title'] ?? 'No Title';
          description = data['description'] ?? 'No description';
          prepTime = data['time'] ?? -1;
          servingSize = data['servings'] ?? -1;
          //reads the url form firestore
          imageUrl = data['imageUrl'] ?? '';

          tags = data['Tags'] ?? [];
          ingredients = data['ingredients'] ?? [];
          procedure = data['procedure'] ?? [];

          if(title.length > 14) {
            title_short = title.substring(0, 11) + '...';
          }
          else {
            title_short = title;
          }
        }
      } else {
        print("No data found at the specified document.");
      }
    } catch (error) {
      print("Error reading data: $error");
    }
  }

  displayData(){
    print("title $title");
    print("Image URL: $imageUrl");
    print("recipe id $recipeId");
  }

}
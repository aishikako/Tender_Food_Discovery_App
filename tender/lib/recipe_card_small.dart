import 'dart:math' as Math;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tender/recipe_card.dart';

class RecipeCardSmall extends StatefulWidget {
  final RecipeCard recipe; // Add this line to hold the recipe data

  const RecipeCardSmall({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeCardSmallState createState() => _RecipeCardSmallState();
}

// different styles
class _RecipeCardSmallState extends State<RecipeCardSmall> {
  final TextStyle bodyStyle = GoogleFonts.radioCanada(
    textStyle: TextStyle(fontSize: 15),
  );

  final TextStyle tagsStyle = GoogleFonts.gothicA1(
    textStyle: TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // In case the serving count did not parse properly, display n/a
    String servingCount = "${widget.recipe.servingSize}";
    if (widget.recipe.servingSize <= 0) {
      servingCount = "n/a";
    }

    // In case the estimated time to make did not parse properly, display n/a
    String timeEstimate = "${widget.recipe.prepTime}";
    if (widget.recipe.prepTime <= 0) {
      timeEstimate = "n/a";
    }

    return Container(
      width: 500 * 0.75, // 3/4 of screen width
      height: 107, //
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 235, 238),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color.fromARGB(255, 236, 197, 197), // Border color
          width: 3, // Border width
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  //title
                  Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      widget.recipe.title_short,
                      style: GoogleFonts.jua(
                        textStyle: TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      //serving count
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/servings_img.png',
                          width: 20,
                          fit:
                              BoxFit
                                  .cover, // Cover the container with the image
                        ),
                        Text(
                          '$servingCount servings',
                          style: bodyStyle,
                        ),
                      ],
                    ),
                  ),

                  //time count w/ image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          'assets/time_img.png',
                          width: 20,
                          fit:
                              BoxFit
                                  .cover, // Cover the container with the image
                        ),
                      ),

                      Text(
                        '${timeEstimate} minutes',
                        style: bodyStyle,
                      ),
                    ],

                  ),
                ],
              ),
            ),

            //tags
            Expanded(
              flex: 1,
              child: Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,

                children: List.generate(
                  Math.min(widget.recipe.tags.length, 3),
                  (index) {
                    final tag = widget.recipe.tags[index].toLowerCase();
                    Widget tagSymbol;

                  // assigning tag to icon/image displayed
                    if (tag == 'eggless') {
                      tagSymbol = Image.asset(
                        'assets/eggless.png',
                        height: 15,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      );
                    } else if (tag == 'vegan') {
                      tagSymbol = Icon(
                        Icons.eco,
                        size: 16,
                        color: Colors.white,
                      );
                    } else if (tag == 'gluten free') {
                      tagSymbol = Text("GF", style: tagsStyle);
                    } else if (tag == 'dairy free') {
                      tagSymbol = Text("DF", style: tagsStyle);
                    } else if (tag == 'dessert') {
                      tagSymbol = Icon(
                        Icons.bakery_dining,
                        size: 16,
                        color: Colors.white,
                      );
                    } else if (tag == 'seafood') {
                      tagSymbol = Icon(
                        Icons.set_meal,
                        size: 16,
                        color: Colors.white,
                      );
                    } else if (tag == 'vegetarian') {
                      tagSymbol = Text("V", style: tagsStyle);
                    } else {
                      tagSymbol = Text("?", style: tagsStyle);
                    }

                    // returning the tag
                    return Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 70, 72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: tagSymbol,
                    );
                  },
                ),
              ),
            ),

          //image of the food
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 8, top: 5, bottom: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      widget.recipe.imageUrl.isNotEmpty
                          ? Image.network(
                            widget.recipe.imageUrl,
                            fit: BoxFit.cover,
                          )
                          : Image.asset('assets/pasta.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math' as Math;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tender/recipe_card.dart';

class RecipeCardMedium extends StatefulWidget {
  final RecipeCard recipe; // Add this line to hold the recipe data

  const RecipeCardMedium({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeCardMediumState createState() => _RecipeCardMediumState();
}

// different styles
class _RecipeCardMediumState extends State<RecipeCardMedium> {
  final TextStyle bodyStyle = GoogleFonts.radioCanada(
    textStyle: TextStyle(fontSize: 20),
  );

  final TextStyle tagsStyle = GoogleFonts.gothicA1(
    textStyle: TextStyle(
      fontSize: 16,
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 500 * 0.75, // 3/4 of screen width
          height: 800 * 0.67, // 2/3 of screen height
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 235, 238),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color.fromARGB(255, 236, 197, 197), // Border color
              width: 3, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // food image
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                  //overflow: Overflow
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  child:
                      widget.recipe.imageUrl.isNotEmpty
                          ? Image.network(
                            widget.recipe.imageUrl,
                            fit: BoxFit.cover,
                          )
                          : Image.asset('assets/pasta.png', fit: BoxFit.cover),
                ),
              ),

              //title
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 16, left: 16, top: 6),
                child: Text(
                  widget.recipe.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jua(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),

                child: Text(
                  widget.recipe.description,
                  style: bodyStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Divider(
                color: const Color.fromARGB(213, 39, 38, 38),
                thickness: 1.1,
                indent: 17.0,
                endIndent: 17.0,
              ),

              //serving size and time
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/servings_img.png',
                          width: 30,
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

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.access_time,
                            size: 30, // or any size you prefer
                            color: Colors.black, // or your chosen color
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
              Row(
                //showing all the tags
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(Math.min(widget.recipe.tags.length, 3), (
                  index,
                ) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 3,
                      left: 10,
                      right: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 230, 70, 72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(widget.recipe.tags[index], style: tagsStyle),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

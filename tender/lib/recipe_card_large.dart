import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tender/recipe_card.dart';

class RecipeCardLarge extends StatefulWidget {
  final RecipeCard recipe; // Add this line to hold the recipe data

  const RecipeCardLarge({Key? key, required this.recipe}) : super(key: key);

  @override
  RecipeCardLargeState createState() => RecipeCardLargeState();
}

//font styles
class RecipeCardLargeState extends State<RecipeCardLarge> {

  //different styles
  final TextStyle bodyStyle = GoogleFonts.radioCanada(
    textStyle: TextStyle(fontSize: 20),
  );

  final TextStyle headingStyle = GoogleFonts.radioCanada(
    textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
        child: Hero(
          tag: widget.recipe.recipeId,
          child: Material(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 235, 238),
                border: Border.all(
                  color: const Color.fromARGB(
                    255,
                    236,
                    197,
                    197,
                  ), // Border color
                  width: 3, // Border width
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // food image
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      width:
                          double
                              .infinity, // Make the image container full width
                      height: 250, // Adjust the height as needed
                      //making a rounded top image
                      child: ClipRRect(
                        child:
                            widget.recipe.imageUrl.isNotEmpty
                                ? Image.network(
                                  widget.recipe.imageUrl,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  'assets/pasta.png',
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),

                    //title
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: Text(
                        widget.recipe.title,
                        style: GoogleFonts.jua(
                          textStyle: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    //description
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16),

                      child: Text(widget.recipe.description, style: bodyStyle),
                    ),

                    Divider(
                      color: const Color.fromARGB(213, 39, 38, 38),
                      thickness: 1.1,
                      indent: 17.0,
                      endIndent: 17.0,
                    ),

                    //prep time and serving size
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

                    //tags
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // children: List.generate(widget.recipe.tags.length, (index) [
                      children: List.generate(widget.recipe.tags.length, (
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
                          child: Text(
                            widget.recipe.tags[index],
                            style: tagsStyle,
                          ),
                        );
                      }),
                    ),
                    Divider(
                      color: const Color.fromARGB(213, 39, 38, 38),
                      thickness: 1.1,
                      indent: 17.0,
                      endIndent: 17.0,
                    ),

                    //ingredients
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Ingredients', style: headingStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 3, // Wider items; adjust for wrapping
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 2,
                        children: List.generate(
                          widget.recipe.ingredients.length,
                          (index) {
                            return Center(
                              child: Text(
                                widget.recipe.ingredients[index],
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),


                    Divider(
                      color: const Color.fromARGB(213, 39, 38, 38),
                      thickness: 1.1,
                      indent: 17.0,
                      endIndent: 17.0,
                    ),

                    //procedure
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Procedure', style: headingStyle),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: List.generate(widget.recipe.procedure.length, (
                          index,
                        ) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            child: Text(
                              '${index + 1}. ${widget.recipe.procedure[index]}',
                              textAlign: TextAlign.left,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

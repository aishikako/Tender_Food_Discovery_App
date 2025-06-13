import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:tender/recipe_card_large.dart';
import 'package:tender/globals.dart';
import 'package:tender/recipe_card_manager.dart';

import 'package:tender/recipe_card.dart';

import 'package:tender/filterButton.dart';
import 'package:tender/recipe_card_medium.dart';
import 'package:tender/recipe_card_small.dart';
import 'package:tender/sign_in_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:tender/recipe_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setAuthPersistence();
  await RecipeCardManager.createRecipeCards();
  RecipeCardManager.displayIds();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return MyStatefulWidget(); // Show home page when signed in
        } else {
          return SignInPage(); // Show login page if not signed in
        }
      },
    );
  }
}

// Widget monitors the state of the BottomNavigationBar
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

// Keep track of the selected tab for the navigation bar & display it on screen
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Key _tCardContainerKey = ValueKey(0);

  void _rebuildTCardOnly() {
    if(mounted){
      setState(() {
      // This creates a new, unique key
      _tCardContainerKey = ValueKey(DateTime.now().millisecondsSinceEpoch);
    });
    }
  }

  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // List to keep track of the saved recipes
  List<String> savedRecipe = [];

  // TextStyle for the text displayed in each tab
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  TCardController _controller = TCardController();
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

//filtering out the recipe card full list (removing already viewed cards too)
  Future<List<Widget>> getFilteredRecipeCards() async {
    await RecipeCardManager.getRecipeLists();
    List<Widget> filteredCards = [];
    filteredCardsId = [];

    await RecipeCardManager.getFilters();
    List<String> appliedFilters = RecipeCardManager.activatedFilters;
    bool addRecipe;
    // If the recipe has not already been saved or disliked, then check filters applied, and add recipe if applicable
    for (var recipe in RecipeCardManager.recipeCards) {
      addRecipe = true;
      if (!RecipeCardManager.savedRecipeIds.contains(recipe.recipeId) &&
       !RecipeCardManager.dislikedRecipeIds.contains(recipe.recipeId)) {
        // If it doesn't have all the active filters, then don't show it
          for(String filter in appliedFilters) {
            if(!recipe.tags.contains(filter)) {
              addRecipe = false;
            }
          }
          // Add the recipe to the list of cards to show
          if(addRecipe) {
            filteredCardsId.add(recipe.recipeId);
            filteredCards.add(
              buildRecipeCardOverlay(
                context,
                Hero(
                  tag: recipe.recipeId,
                  child: RecipeCardMedium(recipe: recipe),
                ),
                recipe,
              ),
            );
          }
      }
    }
    // When the user finishes going through all recipe cards, let them know there's no more (works with filters too)
    filteredCards.add(Center(child: Text('No new recipes.', style:GoogleFonts.jua(fontSize: 50))));
    return filteredCards;
  }

  // For showing full details of recipes when tapped on
  late OverlayEntry recipeOverlay;
  late List<String> filteredCardsId;

  // List of widgets to display in each tab
  List<Widget> get _widgetOptions => [
    Container(
      key: _tCardContainerKey, // 🔑 Changing this forces rebuild
      child: 
      FutureBuilder<List<Widget>>(
        future: getFilteredRecipeCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // show spinner
          } else if (snapshot.hasError) {
            return Text('Error loading cards');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No cards available');
          } else {
            return TCard(
      controller: _controller,

      onForward: (index, info) async {
        if (info.direction == SwipDirection.Right) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid) // reference the actual user's document
                .set({
                  'saved_recipes': FieldValue.arrayUnion([
                    filteredCardsId[index-1], //index starts at 1 not 0, so we add -1
                  ]),
                }, SetOptions(merge: true));
          }
        } else {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid) // reference the actual user's document
                .set({
                  'disliked_recipes': FieldValue.arrayUnion([
                    filteredCardsId[index-1],
                  ]),
                }, SetOptions(merge: true));
          }
        }
      },
      onBack: (index, info) {
        print(index);
      },
      onEnd: () {
        print('end');
      },
      size: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      cards:
        snapshot.data!,
    );}},),
    ),
    // Saved Recipes
    Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(
              child: Text('No saved recipes yet.', style: optionStyle),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> savedRecipeIds = data['saved_recipes'] ?? [];

          if (savedRecipeIds.isEmpty) {
            return const Center(
              child: Text('No saved recipes yet.', style: optionStyle),
            );
          }

          return FutureBuilder<List<RecipeCard>>(
            future: fetchSavedRecipes(),
            builder: (context, recipeSnapshot) {
              if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes = recipeSnapshot.data ?? [];

              return 
                ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];

                    return Container(
                      child: buildRecipeCardOverlay(
                        context,

                        Dismissible(
                          key: Key(recipe.recipeId),
                          onDismissed: (direction) async {
                              await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                                'saved_recipes': FieldValue.arrayRemove([recipe.recipeId])
                              });

                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid) // reference the actual user's document
                                    .set({
                                      'disliked_recipes': FieldValue.arrayUnion([recipe.recipeId]),
                                    }, SetOptions(merge: true));
                              }
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(right: 20, left: 20),
                            color: Color.fromARGB(255, 230, 70, 72),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.redAccent,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Hero(
                              tag: recipe.recipeId,
                              child: Material(
                                child: Center(
                                  child: RecipeCardSmall(recipe: recipe),
                                ),
                              ),
                            ),
                          ),
                        ),

                        recipe,
                      ),
                    );
                  },
                );
              
            },
          );
        },
      ),
    ),
  ];

  //when tapped, the large recipe card is shown
  Widget buildRecipeCardOverlay(
    BuildContext context,
    Widget tapWidget,
    RecipeCard recipe,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SafeArea(
                  child: Center(
                    // Center constrains it and avoids overflow
                    child: Material(child: RecipeCardLarge(recipe: recipe)),
                  ),
                ),
                //child: RecipeCardLarge(recipe: recipe),
              );
            },
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: tapWidget,
    );
  }

  // gets saved recipe ids on firestore and returns all of those recipe cards
  Future<List<RecipeCard>> fetchSavedRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final docSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final data = docSnapshot.data();
    if (data == null || data['saved_recipes'] == null) return [];

    List<dynamic> savedIds = data['saved_recipes'];

    while (RecipeCardManager.recipeCards.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    List<RecipeCard> savedRecipeCards =
        RecipeCardManager.recipeCards
            .where((card) => savedIds.contains(card.recipeId))
            .toList();

    return savedRecipeCards;
  }

  // Method to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Draw bottomNavigationBar for user to see
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Draw bar at top of screen with logo and buttons
      appBar: AppBar(
        title: Text(
          'Tender',
          style: GoogleFonts.jua(
            textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        actions:
            _selectedIndex == 0
                ? [
                  // Button at top of screen for filtering
                  FiltersButton(onTapFilter: _rebuildTCardOnly),
                  // Spacing at top
                  Padding(
                    padding: EdgeInsets.only(right: 13),
                    // Log-out button at top of screen
                    child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      _logout();
                    },
                  ),
                  ),
                ]
                : null,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // To Go To The Home Page
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            //backgroundColor: Colors.pinkAccent,
          ),

          // To Go To The Saved Recipes Tab
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Saved Recipes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

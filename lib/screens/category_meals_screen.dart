import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const String routeName = "/category-meals";
  // final String categoryId;
  // final String categoryTitle;
  final List<Meal> availableMeals;
  const CategoryMealsScreen({required this.availableMeals, Key? key})
      : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String? categoryTitle;
  List<Meal>? displayedMeals;
  String? categoryColor;

  @override
  void didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    categoryTitle = routeArgs["title"];
    categoryColor = routeArgs["color"];
    final String? categoryId = routeArgs["id"];
    displayedMeals = widget.availableMeals.where(((meal) {
      return meal.categories.contains(categoryId);
    })).toList();
    super.didChangeDependencies();
  }

  void _removeMeal(id) {
    setState(() {
      displayedMeals!.removeWhere((meal) => meal.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle as String),
        backgroundColor: Color(int.parse(categoryColor as String)),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: ((context, index) {
            return MealItem(
              id: displayedMeals![index].id,
              title: displayedMeals![index].title,
              imageUrl: displayedMeals![index].imageUrl,
              duration: displayedMeals![index].duration,
              complexity: displayedMeals![index].complexity,
              affordability: displayedMeals![index].affordability,
              color: categoryColor,
              refresh: () => null,
            );
          }),
          itemCount: displayedMeals!.length,
        ),
      ),
    );
  }
}

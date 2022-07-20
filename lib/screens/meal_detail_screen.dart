import "package:flutter/material.dart";
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = "/meal-detail";
  final Function toggleFavorite;
  final Function isMealFavorite;
  bool changed = false;
  MealDetailScreen(
      {required this.toggleFavorite, required this.isMealFavorite, Key? key})
      : super(key: key);
  Widget buildSectionTitle(String text, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    final String mealId = routeArgs["id"] as String;
    final String color = routeArgs["color"] as String;
    final Function refresh = routeArgs["refresh"] as Function;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
        backgroundColor: Color(int.parse(color)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              selectedMeal.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          buildSectionTitle("Ingredients", context),
          buildContainer(
            ListView.builder(
              itemBuilder: ((context, index) {
                return Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text(selectedMeal.ingredients[index])),
                );
              }),
              itemCount: selectedMeal.ingredients.length,
            ),
          ),
          buildSectionTitle("Steps", context),
          buildContainer(ListView.builder(
            itemBuilder: ((context, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Text("#${index + 1}")),
                      title: Text(selectedMeal.steps[index]),
                    ),
                    const Divider(),
                  ],
                )),
            itemCount: selectedMeal.steps.length,
          )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isMealFavorite(mealId) ? Icons.star : Icons.star_border),
        onPressed: () {
          toggleFavorite(mealId);
          refresh();
        },
      ),
    );
  }
}

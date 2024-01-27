import 'package:flutter/material.dart';
import 'package:news_app/news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("NEWS APP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "WELCOME TO GLOBAL NEWS! \nCHOOSE YOUR FAVOURITE CATEGORY...",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildCategoryCheckboxes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCheckboxes(BuildContext context) {
  List<bool> selectedCategories = List.generate(categoryItems.length, (index) => false);

  return Column(
    children: List.generate(categoryItems.length, (index) {
      return Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(categoryItems[index]),
          trailing: Checkbox(
            value: selectedCategories[index],
            onChanged: (bool? value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage(selectedCategory: categoryItems[index]),
                ),
              );
            },
          ),
        ),
      );
    }),
  );
}

}

import 'package:defcon/constants/category.dart';
import 'package:defcon/database/homedb.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  final int id;
  const CategoryPage({
    super.key,
    required this.categoryName,
    required this.id,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Map<String, dynamic>>> foodsFuture;

  @override
  void initState() {
    super.initState();
    foodsFuture = getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final foods = snapshot.data!;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 28,
                        ),
                      ),
                      const SizedBox(
                        width: 130,
                      ),
                      Text(
                        widget.categoryName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: foods
                          .where((food) => food['catID'] == widget.id)
                          .toList()
                          .length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final categoryItem = foods
                            .where((food) => food['catID'] == widget.id)
                            .toList()[index];
                        return Category(
                          id: categoryItem['id'],
                          catID: categoryItem['catID'],
                          image: categoryItem['imageUrl'],
                          foodName: categoryItem['foodName'],
                          price: categoryItem['price'],
                          description: categoryItem['description'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

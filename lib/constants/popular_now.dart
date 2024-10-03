import 'package:defcon/screens/description_page.dart';
import 'package:flutter/material.dart';

class PopularNow extends StatelessWidget {
  final int id;
  final int catID;
  final String image;
  final String foodName;
  final double price;
  final String description;
  const PopularNow({
    super.key,
    required this.id,
    required this.catID,
    required this.image,
    required this.foodName,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return DescriptionPage(
                  id: id,
                  catID: catID,
                  image: image,
                  foodName: foodName,
                  price: price,
                  description: description,
                );
              },
            ),
          );
        },
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.network(
                  image,
                  width: 120,
                  height: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  foodName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$ $price',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

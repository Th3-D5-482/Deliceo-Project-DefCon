import 'package:defcon/screens/description_page.dart';
import 'package:flutter/material.dart';

class Recomended extends StatelessWidget {
  final int id;
  final int catID;
  final String image;
  final String foodName;
  final double price;
  final String description;
  const Recomended({
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
        padding: const EdgeInsets.all(8.0),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(
                    image,
                    width: 230,
                    height: 153,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    foodName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '\$ $price',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

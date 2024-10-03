import 'package:defcon/database/cartdb.dart';
import 'package:defcon/database/favoritesdb.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  final int id;
  final int catID;
  final String image;
  final String foodName;
  final double price;
  final String description;
  const DescriptionPage({
    super.key,
    required this.id,
    required this.catID,
    required this.image,
    required this.foodName,
    required this.price,
    required this.description,
  });

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/descriPg_image.png',
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 28,
                        ),
                      ),
                      const SizedBox(
                        width: 323,
                      ),
                      GestureDetector(
                        onTap: () {
                          addToFavorites(
                            widget.id,
                            widget.catID,
                            widget.foodName,
                            widget.image,
                            widget.price,
                            widget.description,
                            context,
                          );
                        },
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Image.network(
                    widget.image,
                    width: 289,
                    height: 149,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.foodName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          '\$ ${widget.price}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            addToCart(
                              widget.id,
                              widget.catID,
                              widget.foodName,
                              widget.image,
                              widget.price,
                              widget.description,
                              context,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Add to Cart',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

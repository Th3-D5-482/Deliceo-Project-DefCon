import 'package:defcon/constants/app_name.dart';
import 'package:defcon/constants/delete_confirmation_dialog.dart';
import 'package:defcon/database/cartdb.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final int currentPage;
  const CartPage({
    super.key,
    required this.currentPage,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<List<Map<String, dynamic>>> cartStream;

  @override
  void initState() {
    super.initState();
    cartStream = getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          final cart = snapshot.data!;
          return Column(
            children: [
              const AppName(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Image.asset('assets/images/bg_image.png'),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Cart',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: cart.isEmpty
                                ? const Center(
                                    child: Text('Your cart is empty'),
                                  )
                                : ListView.builder(
                                    itemCount: cart.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final cartItems = cart[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.network(
                                                      cartItems['imageUrl'],
                                                      width: 80,
                                                      height: 80,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cartItems['foodName'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                        Text(
                                                          '\$ ${cartItems['totalPrice']}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    incrementFavorites(
                                                                        cartItems[
                                                                            'id']);
                                                                  });
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                                child: const Icon(
                                                                    Icons
                                                                        .add_rounded),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                '${cartItems['numberInCart']}'),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  decrementFavorites(
                                                                      cartItems[
                                                                          'id']);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                                child: const Icon(
                                                                    Icons
                                                                        .remove_rounded),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        deleteConfirmationDialog(
                                                            widget.currentPage,
                                                            cartItems['id'],
                                                            context);
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 30,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

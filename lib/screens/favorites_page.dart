import 'package:defcon/constants/app_name.dart';
import 'package:defcon/constants/delete_confirmation_dialog.dart';
import 'package:defcon/database/favoritesdb.dart';
import 'package:defcon/screens/description_page.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final int currentPage;
  const FavoritesPage({
    super.key,
    required this.currentPage,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Stream<List<Map<String, dynamic>>> favoriteStream;

  @override
  void initState() {
    super.initState();
    favoriteStream = getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: favoriteStream,
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
          final favorites = snapshot.data!;
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
                            'Favorites',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: favorites.isEmpty
                                ? const Center(
                                    child: Text('No favorites yet'),
                                  )
                                : ListView.builder(
                                    itemCount: favorites.length,
                                    itemBuilder: (context, index) {
                                      final favoriteItem = favorites[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return DescriptionPage(
                                                  id: favoriteItem['id'],
                                                  catID: favoriteItem['catID'],
                                                  image:
                                                      favoriteItem['imageUrl'],
                                                  foodName:
                                                      favoriteItem['foodName'],
                                                  price: favoriteItem['price'],
                                                  description: favoriteItem[
                                                      'description'],
                                                );
                                              },
                                            ));
                                          },
                                          child: Card(
                                            elevation: 10,
                                            child: ListTile(
                                              title: Text(
                                                favoriteItem['foodName'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              subtitle: Text(
                                                '\$ ${favoriteItem['price']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              leading: Image.network(
                                                favoriteItem['imageUrl'],
                                                width: 80,
                                                height: 80,
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () {
                                                  deleteConfirmationDialog(
                                                    widget.currentPage,
                                                    favoriteItem['id'],
                                                    context,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                ),
                                              ),
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

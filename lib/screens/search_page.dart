import 'package:defcon/constants/app_name.dart';
import 'package:defcon/database/homedb.dart';
import 'package:defcon/screens/category_page.dart';
import 'package:defcon/screens/description_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController search = TextEditingController();
  late String searchInformation = '';
  late List<Map<String, dynamic>> foodList;
  late String searchFoodName = '';
  late double searchPrice = 0;
  late String searchImageUrl = '';
  late int searchID = 0;
  late int searchCatID = 0;
  late String searchDescription = '';
  late bool isItemFound = false;
  late bool isSearchPerformed = false;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  void searchFunction(
    String searchInformation,
  ) async {
    foodList = await getFoods();
    bool itemFound = false;
    for (var value in foodList) {
      if (searchInformation == value['foodName']) {
        setState(() {
          searchFoodName = value['foodName'];
          searchPrice = value['price'];
          searchImageUrl = value['imageUrl'];
          searchID = value['id'];
          searchCatID = value['catID'];
          searchDescription = value['description'];
          itemFound = true;
        });
        break;
      }
    }
    setState(() {
      isItemFound = itemFound;
      if (!itemFound) {
        searchFoodName = '';
        searchPrice = 0;
        searchImageUrl = '';
        searchID = 0;
        searchCatID = 0;
        searchDescription = '';
      }
      isSearchPerformed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                            'Search',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: search,
                          onSubmitted: (value) {
                            if (search.text.isNotEmpty) {
                              searchInformation = search.text
                                  .split(' ')
                                  .map((word) =>
                                      word[0].toUpperCase() +
                                      word.substring(1).toLowerCase())
                                  .join(' ');
                              Text(searchInformation);
                              if (searchInformation == 'Burger' ||
                                  searchInformation == 'Burgers') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CategoryPage(
                                          categoryName: 'Burgers', id: 0);
                                    },
                                  ),
                                );
                              } else if (searchInformation == 'Drink' ||
                                  searchInformation == 'Drinks') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CategoryPage(
                                        categoryName: 'Drinks',
                                        id: 1,
                                      );
                                    },
                                  ),
                                );
                              } else if (searchInformation == 'Pizza' ||
                                  searchInformation == 'Pizzas') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CategoryPage(
                                        categoryName: 'Pizzas',
                                        id: 2,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                searchFunction(searchInformation);
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Looking for a delicious meal?',
                            enabledBorder: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 32,
                            ),
                            prefixIconColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return DescriptionPage(
                                  id: searchID,
                                  catID: searchCatID,
                                  image: searchImageUrl,
                                  foodName: searchFoodName,
                                  price: searchPrice,
                                  description: searchDescription,
                                );
                              },
                            ),
                          );
                        },
                        child: isSearchPerformed
                            ? isItemFound
                                ? Card(
                                    elevation: 10,
                                    child: ListTile(
                                      title: Text(
                                        searchFoodName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        '\$ $searchPrice',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      leading: Image.network(
                                        searchImageUrl,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text('No Item found'),
                                  )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

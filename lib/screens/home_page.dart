import 'package:defcon/constants/popular_now.dart';
import 'package:defcon/constants/recomended.dart';
import 'package:defcon/database/homedb.dart';
import 'package:defcon/screens/cart_page.dart';
import 'package:defcon/screens/category_page.dart';
import 'package:defcon/screens/favorites_page.dart';
import 'package:defcon/screens/profile_page.dart';
import 'package:defcon/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentPage,
          children: [
            const SubHomePage(),
            FavoritesPage(
              currentPage: currentPage,
            ),
            CartPage(
              currentPage: currentPage,
            ),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 28,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}

class SubHomePage extends StatefulWidget {
  const SubHomePage({super.key});

  @override
  State<SubHomePage> createState() => _SubHomePageState();
}

class _SubHomePageState extends State<SubHomePage> {
  //final food = foods;
  final PageController _pageController = PageController();
  final List<String> bannerImage = [
    'https://firebasestorage.googleapis.com/v0/b/defcon-8786c.appspot.com/o/Banner%2Fbanner1_image.png?alt=media&token=515c967b-a21a-446a-895e-560e7c6c699a',
    'https://firebasestorage.googleapis.com/v0/b/defcon-8786c.appspot.com/o/Banner%2Fbanner2_image.png?alt=media&token=5c0a4b99-bd42-4697-83fd-c4d3e7fafc9a',
    'https://firebasestorage.googleapis.com/v0/b/defcon-8786c.appspot.com/o/Banner%2Fbanner3_image.png?alt=media&token=f26cdda4-cdb1-426f-a18f-d1a5973614c2',
  ];
  late Future<List<Map<String, dynamic>>> categoriesFuture;
  late Future<List<Map<String, dynamic>>> foodsFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = getCategories();
    foodsFuture = getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([categoriesFuture, foodsFuture]),
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
        final categories = snapshot.data![0];
        final foods = snapshot.data![1];
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Déliceo',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        width: 176,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const SearchPage();
                              },
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 10,
                          ),
                          child: const Icon(
                            size: 28,
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: bannerImage.length,
                        itemBuilder: (context, index) {
                          final String image = bannerImage[index];
                          return Image.network(
                            image,
                            width: 400,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: bannerImage.length,
                        effect: const ScrollingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final categoryItem = categories[index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return CategoryPage(
                                      categoryName:
                                          categoryItem['categoryName'],
                                      id: categoryItem['id'],
                                    );
                                  },
                                ));
                              },
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        categoryItem['imageUrl'],
                                        width: 86,
                                        height: 88,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        categoryItem['categoryName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Popular Now',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PopularNow(
                            id: foods[0]['id'],
                            catID: foods[0]['catID'],
                            image: foods[0]['imageUrl'],
                            foodName: foods[0]['foodName'],
                            price: foods[0]['price'],
                            description: foods[0]['description'],
                          ),
                          PopularNow(
                            id: foods[4]['id'],
                            catID: foods[4]['catID'],
                            image: foods[4]['imageUrl'],
                            foodName: foods[4]['foodName'],
                            price: foods[4]['price'],
                            description: foods[4]['description'],
                          ),
                          PopularNow(
                            id: foods[8]['id'],
                            catID: foods[8]['catID'],
                            image: foods[8]['imageUrl'],
                            foodName: foods[8]['foodName'],
                            price: foods[8]['price'],
                            description: foods[8]['description'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Recommended',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Recomended(
                            id: foods[1]['id'],
                            catID: foods[1]['catID'],
                            image: foods[1]['imageUrl'],
                            foodName: foods[1]['foodName'],
                            price: foods[1]['price'],
                            description: foods[1]['description'],
                          ),
                          Recomended(
                            id: foods[5]['id'],
                            catID: foods[5]['catID'],
                            image: foods[5]['imageUrl'],
                            foodName: foods[5]['foodName'],
                            price: foods[5]['price'],
                            description: foods[5]['description'],
                          ),
                          Recomended(
                            id: foods[9]['id'],
                            catID: foods[9]['catID'],
                            image: foods[9]['imageUrl'],
                            foodName: foods[9]['foodName'],
                            price: foods[9]['price'],
                            description: foods[9]['description'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

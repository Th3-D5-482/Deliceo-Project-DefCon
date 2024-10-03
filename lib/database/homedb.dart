import 'package:firebase_database/firebase_database.dart';

final DatabaseReference dbRefHome = FirebaseDatabase.instance.ref();

Future<List<Map<String, dynamic>>> getCategories() async {
  final DataSnapshot snapshot = await dbRefHome.child('Categories').get();
  if (snapshot.exists) {
    final List<Map<String, dynamic>> exisitngCategories = [];
    List<dynamic> values = snapshot.value as List<dynamic>;
    for (var value in values) {
      exisitngCategories.add({
        'id': value['id'],
        'categoryName': value['categoryName'],
        'imageUrl': value['imageUrl'],
      });
    }
    return exisitngCategories;
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFoods() async {
  final DataSnapshot snapshot = await dbRefHome.child('Foods').get();
  if (snapshot.exists) {
    final List<Map<String, dynamic>> existingFood = [];
    List<dynamic> values = snapshot.value as List<dynamic>;
    for (var value in values) {
      existingFood.add({
        'id': value['id'],
        'catID': value['catID'],
        'foodName': value['foodName'],
        'imageUrl': value['imageUrl'],
        'price': value['price'],
        'description': value['description'],
      });
    }
    return existingFood;
  } else {
    return [];
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DatabaseReference dbRefFavorites =
    FirebaseDatabase.instance.ref('Favorites');

Future addToFavorites(
  int id,
  int catID,
  String foodName,
  String imageUrl,
  double price,
  String description,
  BuildContext context,
) async {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  DatabaseEvent event = await dbRefFavorites
      .child(sanitizedEmailID)
      .orderByChild('id')
      .equalTo(id)
      .once();
  if (event.snapshot.value != null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Already in favorites'),
      ),
    );
  } else {
    await dbRefFavorites.child(sanitizedEmailID).child(id.toString()).set({
      'id': id,
      'catID': catID,
      'foodName': foodName,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favoites'),
      ),
    );
  }
}

Stream<List<Map<String, dynamic>>> getFavorites() async* {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  yield* dbRefFavorites.child(sanitizedEmailID).onValue.map((event) {
    List<Map<String, dynamic>> existingFavorites = [];
    final DataSnapshot snapshot = event.snapshot;
    if (snapshot.exists) {
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null && value is Map) {
            existingFavorites.add({
              'id': value['id'],
              'catID': value['catID'],
              'foodName': value['foodName'],
              'imageUrl': value['imageUrl'],
              'price': value['price'],
              'description': value['description'],
            });
          }
        });
      } else if (snapshot.value is List) {
        List<dynamic> values = snapshot.value as List<dynamic>;
        for (var value in values) {
          if (value != null && value is Map) {
            existingFavorites.add({
              'id': value['id'],
              'catID': value['catID'],
              'foodName': value['foodName'],
              'imageUrl': value['imageUrl'],
              'price': value['price'],
              'description': value['description'],
            });
          }
        }
      }
    }
    return existingFavorites;
  });
}

Future deleteFromFavorites(
  int id,
  BuildContext context,
) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String? email = sharedPref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  final DatabaseEvent event = await dbRefFavorites
      .child(sanitizedEmailID)
      .orderByChild('id')
      .equalTo(id)
      .once();
  if (event.snapshot.value != null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
      ),
    );
    await dbRefFavorites.child(sanitizedEmailID).child(id.toString()).remove();
  }
}

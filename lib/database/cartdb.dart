import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DatabaseReference dbRefCart = FirebaseDatabase.instance.ref('Cart');

Future addToCart(
  int id,
  int catID,
  String foodName,
  String imageUrl,
  double price,
  String description,
  BuildContext context,
) async {
  int numberInCart = 1;
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  final DatabaseEvent event = await dbRefCart
      .child(sanitizedEmailID)
      .orderByChild('id')
      .equalTo(id)
      .once();
  if (event.snapshot.value != null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Already in cart'),
      ),
    );
  } else {
    await dbRefCart.child(sanitizedEmailID).child(id.toString()).set({
      'id': id,
      'catID': catID,
      'foodName': foodName,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'numberInCart': numberInCart,
      'totalPrice': price,
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
      ),
    );
  }
}

Stream<List<Map<String, dynamic>>> getCart() async* {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  yield* dbRefCart.child(sanitizedEmailID).onValue.map((event) {
    List<Map<String, dynamic>> existingCart = [];
    final DataSnapshot snapshot = event.snapshot;
    if (snapshot.exists) {
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          existingCart.add({
            'id': value['id'],
            'catID': value['catID'],
            'foodName': value['foodName'],
            'imageUrl': value['imageUrl'],
            'UnitPrice': value['UnitPrice'],
            'description': value['description'],
            'numberInCart': value['numberInCart'],
            'totalPrice': value['totalPrice'],
          });
        });
      } else if (snapshot.value is List) {
        List<dynamic> values = snapshot.value as List<dynamic>;
        for (var value in values) {
          existingCart.add({
            'id': value['id'],
            'catID': value['catID'],
            'foodName': value['foodName'],
            'imageUrl': value['imageUrl'],
            'price': value['price'],
            'description': value['description'],
            'numberInCart': value['numberInCart'],
            'totalPrice': value['totalPrice'],
          });
        }
      }
    }
    return existingCart;
  });
}

Future deleteFromCart(
  int id,
  BuildContext context,
) async {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  final DatabaseEvent event = await dbRefCart
      .child(sanitizedEmailID)
      .orderByChild('id')
      .equalTo(id)
      .once();
  // ignore: unnecessary_null_comparison
  if (event.snapshot != null) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from cart'),
      ),
    );
    await dbRefCart.child(sanitizedEmailID).child(id.toString()).remove();
  }
}

Future incrementFavorites(
  int id,
) async {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  final DatabaseEvent event =
      await dbRefCart.child(sanitizedEmailID).child(id.toString()).once();
  final DataSnapshot snapshot = event.snapshot;
  if (snapshot.exists) {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    int currentNumberInCart = values['numberInCart'];
    double currentPrice = values['price'];
    currentNumberInCart += 1;
    double newTotalPrice = currentPrice * currentNumberInCart;
    await dbRefCart.child(sanitizedEmailID).child(id.toString()).update({
      'numberInCart': currentNumberInCart,
      'totalPrice': newTotalPrice,
    });
  }
}

Future decrementFavorites(
  int id,
) async {
  SharedPreferences sharePref = await SharedPreferences.getInstance();
  String? email = sharePref.getString('loggedInEmailID');
  String sanitizedEmailID = email.toString().replaceAll('.', ',');
  final DatabaseEvent event =
      await dbRefCart.child(sanitizedEmailID).child(id.toString()).once();
  final DataSnapshot snapshot = event.snapshot;
  if (snapshot.exists) {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    int currentNumberInCart = values['numberInCart'];
    double currentPrice = values['price'];
    currentNumberInCart -= 1;
    double newTotalPrice = currentPrice * currentNumberInCart;
    await dbRefCart.child(sanitizedEmailID).child(id.toString()).update({
      'numberInCart': currentNumberInCart,
      'totalPrice': newTotalPrice,
    });
  }
}

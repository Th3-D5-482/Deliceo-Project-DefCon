import 'package:defcon/database/cartdb.dart';
import 'package:defcon/database/favoritesdb.dart';
import 'package:flutter/material.dart';

void deleteConfirmationDialog(
  int currentPage,
  int id,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Delete Confirmation',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          'Are you sure that you want to delete this item?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              if (currentPage == 1) {
                deleteFromFavorites(id, context);
              } else if (currentPage == 2) {
                deleteFromCart(id, context);
              }
              Navigator.of(context).pop();
            },
            child: Text(
              'Confirm',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('You have '
                  '${appState.favourites.length} favourites:'),
            ),
            for (var pair in appState.favourites)
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(pair.asLowerCase),
              ),
          ],
        );
  }
}



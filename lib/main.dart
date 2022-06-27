import 'package:flutter/material.dart';

import 'home.dart';
import 'cards.dart';
import 'offer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/cards': (context) => const CardsScreen(),
          '/offer': (context) => const OfferScreen(),
        });
  }
}

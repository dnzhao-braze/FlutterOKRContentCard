import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer!"),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Image(
          image: AssetImage('images/Money.png'),
        ),
      ),
    );
  }
}

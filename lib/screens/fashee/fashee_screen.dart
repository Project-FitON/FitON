import 'package:flutter/material.dart';

class FasheeScreen extends StatelessWidget {
  const FasheeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fashee')),
      body: const Center(
        child: Text('Fashee Screen'),
      ),
    );
  }
}

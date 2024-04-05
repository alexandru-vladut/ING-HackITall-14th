import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {

  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Test Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Test Page!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
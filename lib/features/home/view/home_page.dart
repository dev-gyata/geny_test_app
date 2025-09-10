import 'package:flutter/material.dart';
import 'package:geny_test_app/core/models/business_model.dart';
import 'package:geny_test_app/core/widgets/business_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geny Test App'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final business = BusinessModel();
          return BusinessCard(
            value: business,
            titleBuilder: (context, value) {
              return Text('Business ${index + 1}');
            },
            subtitleBuilder: (context, value) {
              return Text('Subtitle ${index + 1}');
            },
            trailingBuilder: (context, value) {
              return Text('Subtitle ${index + 1}');
            },
          );
        },
      ),
    );
  }
}

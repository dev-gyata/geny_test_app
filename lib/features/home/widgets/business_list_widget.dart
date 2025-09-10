import 'package:flutter/material.dart';
import 'package:geny_test_app/core/models/business_model.dart';
import 'package:geny_test_app/core/widgets/business_card.dart';

class BusinessListWidget extends StatelessWidget {
  const BusinessListWidget({required this.businesses, super.key});
  final List<BusinessModel> businesses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: businesses.length,
      itemBuilder: (context, index) {
        final currentBusiness = businesses[index];
        return BusinessCard(
          value: currentBusiness,
          titleBuilder: (context, value) {
            return Text(currentBusiness.name);
          },
          subtitleBuilder: (context, value) {
            return Text(currentBusiness.location);
          },
          trailingBuilder: (context, value) {
            return Text(currentBusiness.phone);
          },
        );
      },
    );
  }
}

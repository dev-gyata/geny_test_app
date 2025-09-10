import 'package:geny_test_app/core/models/business_model.dart';

abstract class BusinessRepository {
  Future<List<BusinessModel>> getBusinesses();
}

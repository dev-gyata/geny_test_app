import 'package:flutter/foundation.dart';
import 'package:geny_test_app/core/models/business_model.dart';
import 'package:geny_test_app/core/models/item_fetcher_model.dart';
import 'package:geny_test_app/core/repositories/business_repository.dart';

class BusinessNotifier extends ChangeNotifier {
  BusinessNotifier({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository;

  final BusinessRepository _businessRepository;
  ItemFetcherModel<List<BusinessModel>> _state =
      const ItemFetcherModel.initial();

  ItemFetcherModel<List<BusinessModel>> get state => _state;

  Future<void> fetchBusinesses() async {
    try {
      _state = const ItemFetcherModel.loading();
      final businessesResponse = await _businessRepository.getBusinesses();
      _state = ItemFetcherModel.success(businessesResponse);
    } catch (e, st) {
      _state = ItemFetcherModel.failed(e.toString(), st);
    }
    notifyListeners();
  }
}

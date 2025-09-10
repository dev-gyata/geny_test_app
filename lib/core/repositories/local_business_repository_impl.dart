import 'package:dio/dio.dart';
import 'package:geny_test_app/core/models/business_model.dart';
import 'package:geny_test_app/core/repositories/business_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(
  as: BusinessRepository,
)
class LocalBusinessRepositoryImpl implements BusinessRepository {
  LocalBusinessRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<BusinessModel>> getBusinesses() async {
    final response = await _dio.get<List<Map<String, dynamic>>>('/businesses');
    final businesses = response.data?.map(BusinessModel.fromMap).toList();
    return businesses ?? [];
  }
}

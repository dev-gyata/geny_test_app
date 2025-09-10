import 'package:dio/dio.dart';
import 'package:geny_test_app/core/interceptors/business_reponse_interceptor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  Dio get dioInstance {
    final dio = Dio();
    dio.interceptors.add(BusinessReponseInterceptor());
    return dio;
  }
}

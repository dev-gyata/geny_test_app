import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geny_test_app/core/interceptors/business_reponse_interceptor.dart';
import 'package:mockito/mockito.dart';

import 'cache_interceptor_test.mocks.dart';

void main() {
  late BusinessReponseInterceptor businessReponseInterceptor;
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    businessReponseInterceptor = BusinessReponseInterceptor();
  });
  group('BusinessReponseInterceptor', () {
    group('- onRequest', () {
      test(
        'should return a response from business data json file with the path '
        'appended with /businesses',
        () async {
          // arrange
          final mockRequestOptions = RequestOptions(
            path: '/businesses',
          );
          final mockHandler = MockRequestInterceptorHandler();
          when(mockHandler.resolve(any)).thenAnswer((_) async {});
          when(mockHandler.next(any)).thenAnswer((_) async {});

          // act
          await businessReponseInterceptor.onRequest(
            mockRequestOptions,
            mockHandler,
          );

          // assert
          verify(
            mockHandler.resolve(any),
          ).called(1);
          verifyNever(
            mockHandler.next(mockRequestOptions),
          );
        },
      );

      test(
        'should return not return a response if the path is not /businesses '
        'and continue to the next interceptor',
        () async {
          // arrange
          final mockRequestOptions = RequestOptions(
            path: '/not-businesses',
          );
          final mockHandler = MockRequestInterceptorHandler();
          when(mockHandler.resolve(any)).thenAnswer((_) async {});
          when(mockHandler.next(any)).thenAnswer((_) async {});

          // act
          await businessReponseInterceptor.onRequest(
            mockRequestOptions,
            mockHandler,
          );

          // assert
          verifyNever(
            mockHandler.resolve(any),
          );
          verify(
            mockHandler.next(mockRequestOptions),
          ).called(1);
        },
      );
    });
  });
}

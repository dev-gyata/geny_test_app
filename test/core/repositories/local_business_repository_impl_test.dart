import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geny_test_app/core/repositories/local_business_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_business_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late Dio dio;
  late LocalBusinessRepositoryImpl localBusinessRepositoryImpl;

  setUpAll(() {
    dio = MockDio();
    localBusinessRepositoryImpl = LocalBusinessRepositoryImpl(dio: dio);
  });
  group('LocalBusinessRepositoryImpl', () {
    group('- getBusinesses', () {
      test(
        'should return a list of businesses model when endpont returns a list',
        () async {
          // arrange
          final mockResponse = Response<List<dynamic>>(
            requestOptions: RequestOptions(path: '/businesses'),
            data: [
              {
                'biz_name': 'Glow & Go Salon',
                'bss_location': 'Atlanta',
                'contct_no': '+1 404 123 4567',
              },
              {
                'biz_name': 'Fresh Cuts Barbershop',
                'bss_location': 'Lagos',
                'contct_no': '+234 802 555 1212',
              },
            ],
            statusCode: 200,
          );
          when(
            dio.get<List<dynamic>>('/businesses'),
          ).thenAnswer((_) async => Future.value(mockResponse));

          // act
          final result = await localBusinessRepositoryImpl.getBusinesses();

          // assert
          expect(result.length, 2);
        },
      );

      test(
        'should return an empty list when endpont returns an empty list',
        () async {
          // arrange
          final mockResponse = Response<List<dynamic>>(
            requestOptions: RequestOptions(path: '/businesses'),
            data: [],
            statusCode: 200,
          );
          when(
            dio.get<List<dynamic>>('/businesses'),
          ).thenAnswer((_) async => Future.value(mockResponse));

          // act
          final result = await localBusinessRepositoryImpl.getBusinesses();

          // assert
          expect(result.length, 0);
        },
      );

      test(
        'should throw an error when endpont returns an error',
        () async {
          // arrange
          final mockException = DioException(
            requestOptions: RequestOptions(
              path: '/businesses',
            ),
          );
          when(
            dio.get<List<dynamic>>('/businesses'),
          ).thenThrow(mockException);

          expect(
            () async => localBusinessRepositoryImpl.getBusinesses(),
            throwsA(isA<DioException>()),
          );
        },
      );

      test(
        'Should throw an ArgumentError data returned is not valid thus does '
        'not conform to the business model',
        () async {
          // arrange
          final mockResponse = Response<List<dynamic>>(
            requestOptions: RequestOptions(path: '/businesses'),
            data: [
              {
                'biz_name': '',
                'bss_location': '',
                'contct_no': '333',
              },
            ],
            statusCode: 200,
          );
          when(
            dio.get<List<dynamic>>('/businesses'),
          ).thenAnswer((_) async => Future.value(mockResponse));

          // assert
          expect(
            () => localBusinessRepositoryImpl.getBusinesses(),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    });
  });
}

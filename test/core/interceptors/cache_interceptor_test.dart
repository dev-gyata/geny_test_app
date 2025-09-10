import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geny_test_app/core/interceptors/cache_interceptor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cache_interceptor_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RequestInterceptorHandler>(),
  MockSpec<ErrorInterceptorHandler>(),
])
void main() {
  late CacheInterceptor cacheInterceptor;

  setUpAll(() {
    cacheInterceptor = CacheInterceptor();
  });

  setUp(() {
    cacheInterceptor.clearCache();
  });
  group('Cache interceptor ...', () {
    test(
      'should return the response from cache if the request is found',
      () async {
        // arrange
        final mockRequestOptions = RequestOptions(
          path: '/businesses',
        );
        final mockResponse = Response<List<dynamic>>(
          requestOptions: mockRequestOptions,
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
        // Put the response in the cache
        cacheInterceptor.addToCache(CacheEntry(mockResponse));
        final mockHandler = MockRequestInterceptorHandler();
        when(mockHandler.resolve(mockResponse)).thenAnswer((_) async {});
        when(mockHandler.next(mockRequestOptions)).thenAnswer((_) async {});

        // act
        cacheInterceptor.onRequest(
          mockRequestOptions,
          mockHandler,
        );

        // assert
        // verifies that the handler.resolve method is called with the response
        // from the cache
        verify(mockHandler.resolve(mockResponse)).called(1);

        verifyNever(mockHandler.next(mockRequestOptions));
      },
    );

    test(
      'should continue to the next interceptor if the request is not found in the cache',
      () async {
        // arrange
        final mockRequestOptions = RequestOptions(
          path: '/businesses',
        );
        final mockResponse = Response<List<dynamic>>(
          requestOptions: mockRequestOptions,
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
        final mockHandler = MockRequestInterceptorHandler();
        when(mockHandler.resolve(mockResponse)).thenAnswer((_) async {});
        when(mockHandler.next(mockRequestOptions)).thenAnswer((_) async {});

        // act
        cacheInterceptor.onRequest(
          mockRequestOptions,
          mockHandler,
        );

        // assert
        // verifies that the handler.next method is called with the request options
        verify(mockHandler.next(mockRequestOptions)).called(1);

        verifyNever(mockHandler.resolve(mockResponse));
      },
    );

    test('Should Return the response from the cache if onError is called', () {
      // arrange
      final mockRequestOptions = RequestOptions(
        path: '/businesses',
      );
      final mockResponse = Response<List<dynamic>>(
        requestOptions: mockRequestOptions,
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

      final mockErrorHandler = MockErrorInterceptorHandler();
      when(mockErrorHandler.resolve(mockResponse)).thenAnswer((_) async {});
      when(mockErrorHandler.next(any)).thenAnswer((_) async {});
      cacheInterceptor.addToCache(CacheEntry(mockResponse));

      // act
      // ignore: cascade_invocations
      cacheInterceptor.onError(
        DioException(
          requestOptions: mockRequestOptions,
        ),
        mockErrorHandler,
      );

      // assert
      verify(mockErrorHandler.resolve(mockResponse)).called(1);
      verifyNever(
        mockErrorHandler.next(DioException(requestOptions: mockRequestOptions)),
      );
    });
  });
}

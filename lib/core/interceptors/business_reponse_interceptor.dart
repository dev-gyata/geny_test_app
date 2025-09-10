import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

class BusinessReponseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // check if request has a path of /businesses
    if (options.path.contains('/businesses')) {
      // read business data from assets
      final businessData = loadBuinessData();
      // response with json data
      return handler.resolve(
        Response(
          requestOptions: options,
          data: businessData,
          statusCode: 200,
        ),
      );
    }
    handler.next(options);
  }

  Future<List<Map<String, dynamic>>> loadBuinessData() async {
    // Load the JSON file as a string from the assets
    final jsonString = await rootBundle.loadString('assets/business_data.json');
    // Decode the JSON string into a Dart Map
    return jsonDecode(jsonString) as List<Map<String, dynamic>>;
  }
}

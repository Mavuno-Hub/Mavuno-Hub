import 'package:dio/dio.dart';

import 'api_service.dart';

class NewsService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        responseType: ResponseType.json
        ));

        fetchNews()async{
          var response = await _dio.get('&language=en');
          return response.data;
        }
}

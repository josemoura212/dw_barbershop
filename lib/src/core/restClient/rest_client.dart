import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/restClient/interceptors/auth_interceptor.dart';

final class RestClient extends DioForBrowser {
  RestClient()
      : super(BaseOptions(
          baseUrl: "http://localhost:8080/",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(minutes: 1),
        )) {
    interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      AuthInterceptor(),
    ]);
  }

  RestClient get auth {
    options.extra["DIO_AUTH_KEY"] = true;
    return this;
  }

  RestClient get unAuth {
    options.extra["DIO_AUTH_KEY"] = false;
    return this;
  }
}

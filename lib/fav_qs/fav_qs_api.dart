import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rickmorty/fav_qs/url_builder.dart';

typedef UserTokenSupplier = Future<String?> Function();

class FavQsApi {
  static const _errorCodeJsonKey = 'error_code';
  static const _errorMessageJsonKey = 'message';

  final Dio _dio;
  final UrlBuilder _urlBuilder;

  FavQsApi({
    required UserTokenSupplier userTokenSupplier,
    @visibleForTesting Dio? dio,
    @visibleForTesting UrlBuilder? urlBuilder,
  })  : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? const UrlBuilder() {
    _dio.setUpAuthHeaders(userTokenSupplier);
    _dio.interceptors.add(
      LogInterceptor(responseBody: false),
    );
  }

  // Future<QuoteListPageRM> getQuoteListPage(
  //   int page, {
  //   String? tag,
  //   String searchTerm = '',
  //   String? favoritedByUsername,
  // }) async {
  //   final url = _urlBuilder.buildGetQuoteListPageUrl(
  //     page,
  //     tag: tag,
  //     searchTerm: searchTerm,
  //     favoritedByUsername: favoritedByUsername,
  //   );
  //   final response = await _dio.get(url);
  //   final jsonObject = response.data;
  //   final quoteListPage = QuoteListPageRM.fromJson(jsonObject);
  //   final firstItem = quoteListPage.quoteList.first;
  //   if (firstItem.id == 0) {
  //     throw EmptySearchResultFavQsException();
  //   }
  //   return quoteListPage;
  // }

  Future<Quote> getQuote(int id) async {
    final url = _urlBuilder.buildGetQuoteUrl(id);
    final response = await _dio.get(url);
    final jsonObject = response.data;
    final quote = Quote.fromJson(jsonObject);
    return quote;
  }
}

extension on Dio {
  static const _appTokenEnvironmentVariableKey = 'fav-qs-app-token';

  void setUpAuthHeaders(UserTokenSupplier userTokenSupplier) {
    const appToken = String.fromEnvironment(
      _appTokenEnvironmentVariableKey,
    );
    options = BaseOptions(headers: {
      'Authorization': 'Token token=$appToken',
    });
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? userToken = await userTokenSupplier();
          if (userToken != null) {
            options.headers.addAll({
              'User-Token': userToken,
            });
          }
          return handler.next(options);
        },
      ),
    );
  }
}

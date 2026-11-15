import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class SearchUsersCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? myUserId = '',
    int? offset = 0,
    int? limit = 10,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'SearchUsers',
      apiUrl:
          'https://etdtsmjisbxyefwjcczw.supabase.co/rest/v1/users?email=ilike.*$searchTerm*&user_id=neq.$myUserId&select=*&offset=$offset&limit=$limit',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0ZHRzbWppc2J4eWVmd2pjY3p3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5MzkwMjgsImV4cCI6MjA5MTUxNTAyOH0.k00xmonliKyuM3EY2IPRD01Mp3r1u813iWRmPGBN-Wk',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0ZHRzbWppc2J4eWVmd2pjY3p3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5MzkwMjgsImV4cCI6MjA5MTUxNTAyOH0.k00xmonliKyuM3EY2IPRD01Mp3r1u813iWRmPGBN-Wk',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

class ApiConstant {
  static const String baseUrlLaravel = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.10.10.158:8000/api',
  );
  static const String publicApiUrl = 'https://gutendex.com';
  static const String publicBooksPath = '/books/';
  static const int publicBooksLimit = 10;
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration publicApiTimeout = Duration(seconds: 10);

  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String logoutPath = '/logout';
  static const String userPath = '/user';
  static const String categoriesPath = '/categories';
  static const String collectionItemsPath = '/collection-items';
}

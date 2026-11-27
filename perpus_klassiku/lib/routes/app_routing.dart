import 'package:flutter/material.dart';

import '../models/collection_item_model.dart';
import '../models/explore_book_model.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/collection_item_detail_page.dart';
import '../screens/explore/explore_detail_page.dart';
import '../screens/main_page.dart';
import '../screens/splash_screen.dart';

class AppRouting {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String exploreDetail = '/explore-detail';
  static const String collection = '/collection';
  static const String collectionItemDetail = '/collection-item-detail';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const MainPage(),
    explore: (_) => const MainPage(initialTab: 0),
    collection: (_) => const MainPage(initialTab: 1),
    profile: (_) => const MainPage(initialTab: 2),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == collectionItemDetail) {
      final item = settings.arguments;
      if (item is CollectionItemModel) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => CollectionItemDetailPage(item: item),
        );
      }

      return MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Data item koleksi tidak tersedia.')),
        ),
      );
    }

    if (settings.name == exploreDetail) {
      final book = settings.arguments;
      if (book is ExploreBookModel) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ExploreDetailPage(book: book),
        );
      }

      return MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Data buku tidak tersedia.')),
        ),
      );
    }
    return null;
  }
}

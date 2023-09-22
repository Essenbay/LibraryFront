import 'package:injectable/injectable.dart';
import 'package:auto_route/auto_route.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/textbook_item_screen.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/textbook_list_screen.dart';
import 'package:libraryfront/feat/home/pages/ebook_list_screen/ebook_list_screen.dart';
import 'package:libraryfront/feat/home/pages/home_screen.dart';
import 'package:libraryfront/feat/main/main_screen.dart';

@Singleton()
@MaterialAutoRouter(
  routes: [
    AutoRoute(page: MainScreen, path: '/'),
    AutoRoute(
      page: HomeTabBar,
      path: '',
      children: [
        AutoRoute(page: TextBookListScreen),
        AutoRoute(page: EbookListScreen),
      ],
    ),
    AutoRoute(page: TextbookItemScreen)
  ],
)
class $AppRouter {}

import 'package:injectable/injectable.dart';
import 'package:auto_route/auto_route.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/textbook_item_screen.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/textbook_list_screen.dart';
import 'package:libraryfront/feat/home/pages/ebook_list_screen/ebook_item_screen.dart';
import 'package:libraryfront/feat/home/pages/ebook_list_screen/ebook_list_screen.dart';
import 'package:libraryfront/feat/home/pages/home_screen.dart';
import 'package:libraryfront/feat/main/main_screen.dart';
import 'package:libraryfront/feat/profile/profile_screen.dart';

@Singleton()
@MaterialAutoRouter(
  routes: [
    AutoRoute(page: MainScreen, path: '/', children: [
      AutoRoute(
        page: HomeTabBar,
        path: '',
        children: [
          AutoRoute(page: TextBookListScreen),
          AutoRoute(page: EbookListScreen),
        ],
      ),
      AutoRoute(page: ProfileScreen),
    ]),
    AutoRoute(page: TextbookItemScreen),
    AutoRoute(page: EbookItemScreen)
  ],
)
class $AppRouter {}

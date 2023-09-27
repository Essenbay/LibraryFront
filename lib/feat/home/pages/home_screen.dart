import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/ebook_list_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/textbook_list_bloc.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<TextbookListBloc>()..add(const TextbookListEvent.fetch()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<EbookListBloc>()..add(const EbookListEvent.fetch()),
        ),
      ],
      child: AutoTabsRouter.tabBar(
        routes: const [
          TextBookListScreenRoute(),
          EbookListScreenRoute(),
        ],
        builder: (context, child, controller) {
          return Scaffold(
            appBar: AppBar(
              title: TabBar(
                controller: controller,
                tabs: const [
                  Tab(
                    child: Text(
                      'Textbooks',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Ebooks',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            body: child,
          );
        },
      ),
    );
  }
}

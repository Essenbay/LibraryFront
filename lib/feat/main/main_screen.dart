import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/core/util/colors.dart';

const Key cartButtonKey = Key('Cart');

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeTabBarRoute(),
        ProfileScreenRoute(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final currentIndex =
            AutoTabsRouter.of(context, watch: true).activeIndex;
        return Scaffold(
          backgroundColor: AppColors.white,
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) async => index == currentIndex
                  ? await clearCurrentTabStack(tabsRouter)
                  : tabsRouter.setActiveIndex(index),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: AppColors.white,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: tabsRouter.activeIndex == 0
                          ? AppColors.primaryLight3
                          : AppColors.greyLight,
                      size: 22,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: tabsRouter.activeIndex == 1
                          ? AppColors.primaryLight3
                          : AppColors.greyLight,
                      size: 22,
                    ),
                    label: ''),
              ]),
        );
      },
    );
  }

  Future<void> clearCurrentTabStack(TabsRouter tabsRouter) async {
    if (tabsRouter.current.router.canPop()) {
      await tabsRouter.current.router.popTop().then(
            (value) async => clearCurrentTabStack(tabsRouter),
          );
    }
    return;
  }
}

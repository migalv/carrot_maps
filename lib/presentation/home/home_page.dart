import 'package:auto_route/auto_route.dart';
import 'package:carrot_maps/presentation/routes/router.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        MapRouter(),
        PlacesRouter(),
      ],
      appBarBuilder: (_, __) => AppBar(
        title: const Text("Carrot Maps"),
      ),
      bottomNavigationBuilder: (_, tabsRouter) => BottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: tr("map"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_on_outlined),
            activeIcon: const Icon(Icons.location_on),
            label: tr("places"),
          )
        ],
      ),
    );
  }
}

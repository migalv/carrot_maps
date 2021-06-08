import 'package:auto_route/annotations.dart';
import 'package:carrot_maps/presentation/home/home_page.dart';
import 'package:carrot_maps/presentation/home/widgets/map_view.dart';
import 'package:carrot_maps/presentation/home/widgets/places_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(path: "/", page: HomePage, initial: true, children: [
      AutoRoute(
        path: "map",
        name: "MapRouter",
        page: MapView,
      ),
      AutoRoute(
        path: "places",
        name: "PlacesRouter",
        page: PlacesView,
      ),
    ]),
  ],
)
class $AppRouter {}

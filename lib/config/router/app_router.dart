import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/config/router/list_router.dart';


final GoRouter appRouter = GoRouter(
  routes: routes,
   initialLocation: '/login',
   debugLogDiagnostics: true,
);


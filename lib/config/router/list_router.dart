import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/views/screens.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: '/',
    name: HomeScreen.screenName,
    builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/login',
    name: LoginScreen.screenName,
    builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    name: RegisterScreen.screenName,
    builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/itinerary',
    name: ItineraryScreen.screenName,
    builder: (BuildContext context, GoRouterState state) => const ItineraryScreen(),
  ),
];

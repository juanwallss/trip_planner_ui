import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/views/itinerary/itinerary_detail_screen.dart';
import 'package:trip_planner_ui/views/itinerary/itinerary_edit_screen.dart';
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
  GoRoute(
    path: '/itinerary/:id',
    name: ItineraryDetailScreen.screenName,
    builder: (BuildContext context, GoRouterState state) {
      final id = state.pathParameters['id'];
      return ItineraryDetailScreen(id: int.parse(id!));
    },
  ),
  GoRoute(
    path: '/itinerary-edit-screen/:id',
    name: ItineraryEditScreen.screenName,
    builder: (context, state) {
      final id = state.pathParameters['id'];
      return ItineraryEditScreen(id: int.parse(id!));
    },
  ),

];

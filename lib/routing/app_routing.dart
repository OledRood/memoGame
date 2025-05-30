import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo/pages/game_page.dart';
import 'package:memo/pages/result_page.dart';
import 'package:memo/pages/start_page.dart';

final router = GoRouter(
  initialLocation: '/startPage',
  routes: [
    GoRoute(
      path: '/startPage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: StartPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation, // Новая страница появляется
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation), // Старая исчезает
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 100), // Общая длительность
      ),
    ),
    GoRoute(
      path: '/gamePage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: GamePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 100),
      ),
    ),
    GoRoute(
      path: '/resultPage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: ResultPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 100),
      ),
    ),
  ],
);

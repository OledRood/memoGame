import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/pages/page_background.dart';
import 'package:memo/pages/start_page.dart';
import 'package:memo/sources/app_colors.dart';
import 'package:memo/theme/theme_data.dart';
import 'package:provider/provider.dart';

import 'bloc/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final bloc = Bloc();
  runApp(Provider<Bloc>.value(value: bloc, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        home: Overlay(
          initialEntries: [
            // OverlayEntry(
            //   builder: (context) => Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topRight,
            //         end: Alignment.bottomLeft,
            //         colors: AppColors.background,
            //       ),
            //     ),
            //   ),
            // ),
            OverlayEntry(
              builder: (context) => StartPage(),
            )
          ],
        ));
  }
}

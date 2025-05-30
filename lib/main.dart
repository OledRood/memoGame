import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/bloc/main_bloc.dart';
import 'package:memo/pages/page_background.dart';
import 'package:memo/routing/app_routing.dart';
import 'package:memo/theme/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(BlocProvider(
    create: (context) => MainBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) => PageBackground()),
            OverlayEntry(
                builder: (context) =>
                    child ?? Center(child: Text('Страница не найдена')))
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/bloc/main_bloc.dart';
import 'package:memo/pages/page_background.dart';
import 'package:memo/pages/start_page.dart';
import 'package:memo/sources/app_colors.dart';
import 'package:memo/theme/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final bloc = Blocc();
  runApp(BlocProvider(
    create: (context) => MainBloc(),
    child: Provider<Blocc>.value(
      value: bloc,
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Overlay(
        initialEntries: [
          OverlayEntry(builder: (context) => PageBackground()),
          OverlayEntry(
              builder: (context) => Navigator(
                    onGenerateRoute: (_) {
                      return MaterialPageRoute(builder: (_) => StartPage());
                    },
                  )),
        ],
      ),
    );
  }
}

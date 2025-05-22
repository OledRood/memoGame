import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/bloc.dart';
import '../sources/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
    return StreamBuilder<List<double>>(
        stream: bloc.progressBarStateListSubject,
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.hasData)
            return SizedBox.shrink();
          List<double> values = snapshot.data!;
          return LinearProgressIndicator(
            minHeight: 15,
            value: values[0] / values[1],
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.progressBarColorValue),
            backgroundColor: AppColors.progressBarColorBackground,
            borderRadius: BorderRadius.circular(110),
          );
        });
  }
}

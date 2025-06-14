import 'package:flutter/cupertino.dart';

import '../sources/app_colors.dart';
import '../sources/app_images.dart';

class PageBackground extends StatelessWidget {
  const PageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: AppColors.background,
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Image.asset(AppImages.pattern),
            ),
          ],
        ));
  }
}

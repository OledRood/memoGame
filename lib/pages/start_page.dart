import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/pages/game_page.dart';

import '../bloc/main_bloc.dart';
import '../enums/page_type.dart';
import '../sources/app_colors.dart';
import '../sources/app_images.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _StartPageContent()),
    );
  }
}

class _StartPageContent extends StatelessWidget {
  const _StartPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 150),
          _LogoWidget(),
          SizedBox(height: 34),
          Text(
            'Quiz'.toUpperCase(),
            style: TextStyle(
                color: AppColors.textLogoOnStartPage,
                fontSize: 46.66,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noir-pro-semi-bold-italic'),
          ),
          Spacer(),
          ButtonContainer(),
          SizedBox(height: 192),
        ],
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 159,
      width: 159,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: AppColors.circleOnStartPage,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Image.asset(AppImages.p),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final PageType currentPageType = state.pageType;
          late String buttonText;
          if (currentPageType == PageType.pause) {
            buttonText = 'Continue';
          } else if (currentPageType == PageType.game) {
            buttonText = '';
          } else {
            buttonText = 'Start';
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GamePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
              BlocProvider.of<MainBloc>(context).add(MainEvent.openGamePage());            },
            child: Container(
              alignment: Alignment.center,
              height: 80,
              width: 348,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColors.buttonOnStartPage,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -4),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.buttonOnStartPage[0],
                    offset: Offset(0, 6),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.81),
                    offset: Offset(0, 6),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                    color: AppColors.textOnStartPageButton,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Noir-pro-semi-bold-italic'),
              ),
            ),
          );
        });
  }
}

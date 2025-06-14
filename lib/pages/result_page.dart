import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo/bloc/main_bloc.dart';
import 'package:memo/pages/start_page.dart';

import '../enums/page_type.dart';
import '../sources/app_colors.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _ResultPageContent()),
    );
  }
}

class _ResultPageContent extends StatelessWidget {
  const _ResultPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<MainBloc, MainState>(builder: (context, state) {
          bool isWin = (state.pageType == PageType.win);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 53),
              _CenterTextWidget(isWin: isWin),
              const SizedBox(height: 34),
              if (isWin) const _CardWidget(),
              const Spacer(),
              isWin
                  ? ButtonContainer(
                      text: "Menu",
                      onTap: () {
                        BlocProvider.of<MainBloc>(context)
                            .add(MainEvent.restartGame());
                        context.go('/startPage');
                      },
                    )
                  : ButtonContainer(
                      text: 'Next',
                      onTap: () {
                        BlocProvider.of<MainBloc>(context)
                            .add(MainEvent.startNextLevel());
                        context.pop();
                      },
                    ),
            ],
          );
        }),
      ],
    );
  }
}

class _CenterTextWidget extends StatelessWidget {
  final bool isWin;

  const _CenterTextWidget({super.key, required this.isWin});

  @override
  Widget build(BuildContext context) {
    return isWin
        ? Text(
            '👑\nYou\nWin!'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.textLogoOnStartPage,
                fontSize: 46.66,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noir-pro-semi-bold-italic'),
          )
        : BlocBuilder<MainBloc, MainState>(builder: (context, state) {
            String levelString = "";
            levelString = "${state.level}";
            return Text(
              '$levelString Level\ncomplite\n\🔥🔥🔥🔥🔥'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textLogoOnStartPage,
                  fontSize: 46.66,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noir-pro-semi-bold-italic'),
            );
          });
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Card(
          color: Colors.white.withOpacity(0.13),
          elevation: 1,
          child: SizedBox(
            width: 250,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CardStatistics(
                  label: 'Playing time:',
                  listOfStatistics: state.playerTimeStatistics,
                ),
                const SizedBox(height: 20),
                _CardStatistics(
                  label: 'Statistics:',
                  listOfStatistics: state.playerGameStatistics,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardStatistics extends StatelessWidget {
  final String label;
  final List<String> listOfStatistics;

  const _CardStatistics(
      {super.key, required this.label, required this.listOfStatistics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Noir-pro-semi-bold-italic',
          ),
        ),
        Container(
          height: 1,
          width: 100,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Column(
            children: List.generate(listOfStatistics.length, (index) {
          return Text(
            listOfStatistics[index],
            style: TextStyle(
                color: Colors.white70, fontFamily: 'Noir-pro-semi-bold-italic'),
          );
        }))
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ButtonContainer({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          text,
          style: TextStyle(
              color: AppColors.textOnStartPageButton,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              fontFamily: 'Noir-pro-semi-bold-italic'),
        ),
      ),
    );
  }
}

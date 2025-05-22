import 'package:flutter/material.dart';
import 'package:memo/components/custom_progressbar.dart';
import 'package:memo/pages/page_background.dart';
import 'package:memo/pages/start_page.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/bloc.dart';
import '../sources/app_colors.dart';
import 'game_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(child: SafeArea(child: _ResultPageContent())),
    );
  }
}

class _ResultPageContent extends StatelessWidget {
  const _ResultPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<GameState>(
            stream: bloc.gameStateSubject,
            builder: (context, snapshot) {
              GameState currentGame = snapshot.data ?? GameState.newLevel;
              bool isWin = currentGame == GameState.win;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 53),
                  _CenterTextWidget(isWin: isWin),
                  SizedBox(height: 34),
                  if (isWin) _CardWidget(),
                  Spacer(),
                  isWin
                      ? ButtonContainer(
                          text: "Menu",
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        StartPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                              (route) => false,
                            );
                          },
                        )
                      : ButtonContainer(
                          text: 'Next',
                          onTap: () {
                            bloc.gameStateSubject.add(GameState.game);
                            Navigator.pop(context);
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
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);

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
        : StreamBuilder<int>(
            stream: bloc.gameLevelSubject,
            builder: (context, snapshot) {
              String levelString = "";
              if (snapshot.data == null || !snapshot.hasData) {
                levelString = '';
              } else {
                levelString = "${snapshot.data! - 1}" ?? '';
              }
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
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);

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
              stream: bloc.listStringFormattedPlayingDate,
            ),
            SizedBox(height: 20),
            _CardStatistics(
                stream: bloc.playerStatisticsSubject,
                label: 'Statistics:')
          ],
        ),
      ),
    );
  }
}

class _CardStatistics extends StatelessWidget {
  final String label;
  final BehaviorSubject<List<String>> stream;

  const _CardStatistics({super.key, required this.stream, required this.label});

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
        StreamBuilder<List<String>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.data == null || !snapshot.hasData) {
                return SizedBox.shrink();
              }
              List<String> textsList = snapshot.data!;

              return Column(
                  children: List.generate(textsList.length, (index) {
                return Text(
                  textsList[index],
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Noir-pro-semi-bold-italic'),
                );
              }));
            }),
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

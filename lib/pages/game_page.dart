import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo/pages/result_page.dart';
import 'package:memo/sources/app_images.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/main_bloc.dart';
import '../enums/page_type.dart';
import '../models/card_class.dart';
import '../sources/app_colors.dart';
import '../sources/grid_values.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        final PageType pageType = state.pageType;
        if (pageType == PageType.nextLevel || pageType == PageType.win) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ResultPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(width: 40),
            BackButton(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(MainEvent.pauseGame());
                Navigator.pop(context);
              },
              color: Colors.white,
              style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(54, 54)),
                  backgroundColor: WidgetStatePropertyAll(Colors.white12)),
            ),
            Spacer(),
            StringLevelContainer(
              padding: const EdgeInsets.symmetric(horizontal: 40),
            ),
          ],
        ),
        body: _GamePageContent(),
      ),
    );
  }
}

class _GamePageContent extends StatefulWidget {
  const _GamePageContent({super.key});

  @override
  State<_GamePageContent> createState() => _GamePageContentState();
}

class _GamePageContentState extends State<_GamePageContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SizedBox(height: 53),
          _ProgressBar(),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 490, width: 348, child: _ReorderableWrapWidget()),
          ),
          DragAndDropButton(),
          Spacer(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class StringLevelContainer extends StatelessWidget {
  final EdgeInsets padding;

  const StringLevelContainer({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        alignment: Alignment.center,
        height: 54,
        width: 108,
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.levelContainerColorBackground, width: 1),
            borderRadius: BorderRadius.circular(77)),
        child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
          return Text(
            "Q${state.level}/${state.maxLevel}".toUpperCase(),
            style: Theme
                .of(context)
                .textTheme
                .labelLarge,
          );
        }),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      return LinearProgressIndicator(
        minHeight: 15,
        value: (state.level - 0.1) / state.maxLevel,
        valueColor: AlwaysStoppedAnimation<Color>(state.isEnableDragAndDrop
            ? AppColors.progressBarColorValueFreezed
            : AppColors.progressBarColorValue),
        backgroundColor: AppColors.progressBarColorBackground,
        borderRadius: BorderRadius.circular(110),
      );
    });
  }
}

class _ReorderableWrapWidget extends StatefulWidget {
  const _ReorderableWrapWidget({super.key});

  @override
  State<_ReorderableWrapWidget> createState() => _ReorderableWrapWidgetState();
}

class _ReorderableWrapWidgetState extends State<_ReorderableWrapWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.pageType != PageType.game) {
          return SizedBox.shrink();
        }
        List<CardClass> _listOfCards = List.from(state.gameField);
        final int gridTypeIndex = state.gridTypeIndex;
        return ReorderableWrap(
            enableReorder: state.isEnableDragAndDrop,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            spacing: _listOfGridValues[gridTypeIndex].crossAxisSpacing,
            runSpacing: _listOfGridValues[gridTypeIndex].mainAxisSpacing,
            children: List.generate(_listOfCards.length, (index) {
              return CardFlipWidget(
                  key: ValueKey<String>(_listOfCards[index].id),
                  card: _listOfCards[index],
                  cardSize: _listOfGridValues[gridTypeIndex].cardSize,
                  imagePadding: _listOfGridValues[gridTypeIndex].imagePadding);
            }),
            onReorder: ((oldIndex, newIndex) {
              final item = _listOfCards.removeAt(oldIndex);

              setState(() {
                _listOfCards.insert(newIndex, item);
              });
              BlocProvider.of<MainBloc>(context)
                  .add(MainEvent.updateGameFieldByGrid(_listOfCards));
            }));
      },
    );
  }

  List<GridValue> _listOfGridValues = [
    GridValue(
      cardSize: Size(120, 120),
      mainAxisSpacing: 35,
      crossAxisSpacing: 40,
      imagePadding: true,
    ),
    GridValue(
      cardSize: Size(90, 90),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      imagePadding: true,
    ),
    GridValue(
      cardSize: Size(65, 65),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      imagePadding: false,
    )
  ];
}

class CardFlipWidget extends StatefulWidget {
  final CardClass card;
  final bool imagePadding;
  final Size cardSize;

  const CardFlipWidget({super.key,
    required this.card,
    required this.imagePadding,
    required this.cardSize});

  @override
  State<CardFlipWidget> createState() => _CardFlipWidgetState();
}

class _CardFlipWidgetState extends State<CardFlipWidget> {
  @override
  Widget build(BuildContext context) {
    final CardClass card = widget.card;
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) async {
        int currentCount = state.listOfSelectedCards.length;
        if (currentCount == 2) {
          await Future.delayed(Duration(seconds: 1));
          if (mounted) {
            BlocProvider.of<MainBloc>(context)
                .add(MainEvent.checkIsCompareOrNextLevel());
          }
        }
      },
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        return AnimatedFlip(
          cardBack: Container(
            height: widget.cardSize.height,
            width: widget.cardSize.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 4, color: Colors.white),
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                card.content,
                fit: BoxFit.cover,
              ),
            ),
          ),
          cardFace: FaceCardWidget(
              size: widget.cardSize, imagePadding: widget.imagePadding),
          isFace: (card.isFace || state.isEnableDragAndDrop),
          onTap: () async {
            if (!card.isGuessed && !card.isFace) {
              BlocProvider.of<MainBloc>(context)
                  .add(MainEvent.addCard(widget.card));
            }
          },
        );
      }),
    );
  }
}

class AnimatedFlip extends StatefulWidget {
  final Widget cardBack;
  final Widget cardFace;
  final VoidCallback onTap;
  final bool isFace;

  const AnimatedFlip({
    required this.cardBack,
    required this.cardFace,
    required this.onTap,
    required this.isFace,
    super.key,
  });

  @override
  State<AnimatedFlip> createState() => _AnimatedFlipState();
}

class _AnimatedFlipState extends State<AnimatedFlip> {
  bool _isEnableDragAndDrop = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        setState(() {
          _isEnableDragAndDrop = state.isEnableDragAndDrop;
        });

      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          tween: Tween<double>(
              begin: _isEnableDragAndDrop ? 0 : 180,
              end: widget.isFace ? 0 : 180),
          builder: (context, value, child) {
            final content = value < 90
                ? widget.cardBack
                : RotationY(rotationY: 180, child: widget.cardFace);

            return RotationY(rotationY: value, child: content);
          },
        ),
      ),
    );
  }
}

class FaceCardWidget extends StatelessWidget {
  final Size size;
  final bool imagePadding;

  const FaceCardWidget(
      {super.key, required this.imagePadding, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: size.width,
        padding: imagePadding ? EdgeInsets.all(34) : EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.cardReverseSide,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(width: 4, color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
        child: Opacity(
          opacity: 0.8,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: AppColors.colorPImage,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: Image.asset(
              AppImages.p,
            ),
          ),
        ));
  }
}

class DragAndDropButton extends StatefulWidget {
  const DragAndDropButton({super.key});

  @override
  State<DragAndDropButton> createState() => _DragAndDropButtonState();
}

class _DragAndDropButtonState extends State<DragAndDropButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        bool _isEnableDragAndDrop = state.isEnableDragAndDrop;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .add(MainEvent.tapOnDragAndDropButton());
                },
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStatePropertyAll(Colors.grey.withOpacity(0.13)),
                  minimumSize: WidgetStatePropertyAll(
                    Size(65, 65),
                  ),
                ),
                child: Icon(
                  _isEnableDragAndDrop ? Icons.cancel_outlined : Icons.settings,
                  size: 25,
                  color: _isEnableDragAndDrop ? Colors.red : Colors.white,
                )),
            SizedBox(height: 9),
            Text(_isEnableDragAndDrop ? 'Stop' : 'Drag and Drop')
          ],
        );
      },
    );
  }
}

class RotationY extends StatelessWidget {
  static const double _degrees2Radians = pi / 180;

  final Widget child;
  final double rotationY;

  const RotationY({required this.child, this.rotationY = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotationY * _degrees2Radians),
      child: child,
    );
  }
}

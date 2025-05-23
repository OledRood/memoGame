import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo/pages/page_background.dart';
import 'package:memo/pages/result_page.dart';
import 'package:memo/sources/app_images.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../bloc/bloc.dart';
import '../models/card_class.dart';
import '../sources/app_colors.dart';
import '../sources/grid_values.dart';

bool _isEnableReorderableWrap = false;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late StreamSubscription<dynamic> _subscription;
  late Bloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of<Bloc>(context, listen: false);
    nextPage();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(width: 40),
            BackButton(
              onPressed: () {
                bloc.gameStateSubject.add(GameState.pause);
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

  void nextPage() {
    _subscription = _bloc.gameStateSubject.listen((gameState) {
      if (gameState == GameState.newLevel || gameState == GameState.win) {
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
    });
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
                height: 522, width: 348, child: GridViewStreamsWrapped()),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEnableReorderableWrap = !_isEnableReorderableWrap;
                });
              },
              child: _isEnableReorderableWrap
                  ? Text('stop')
                  : Text('Drag and drop'))
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
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
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
        child: StreamBuilder<String>(
            stream: bloc.stringLevelContainerSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return SizedBox.shrink();
              }
              return Text(
                snapshot.data!.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
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
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
    return StreamBuilder<List<double>>(
        stream: bloc.progressBarStateListSubject,
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.hasData)
            return SizedBox.shrink();
          List<double> values = snapshot.data!;
          return LinearProgressIndicator(
            minHeight: 15,
            value: (values[0] - 0.1) / values[1],
            valueColor: AlwaysStoppedAnimation<Color>(_isEnableReorderableWrap
                ? AppColors.progressBarColorValueFreezed
                : AppColors.progressBarColorValue),
            backgroundColor: AppColors.progressBarColorBackground,
            borderRadius: BorderRadius.circular(110),
          );
        });
  }
}

class GridViewStreamsWrapped extends StatefulWidget {
  const GridViewStreamsWrapped({super.key});

  @override
  State<GridViewStreamsWrapped> createState() => _GridViewStreamsWrappedState();
}

class _GridViewStreamsWrappedState extends State<GridViewStreamsWrapped> {
  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);

    return StreamBuilder(
        stream: bloc.gridTypeSubject,
        builder: (context, snapshot) {
          int intGridType = snapshot.data ?? 0;
          return StreamBuilder<List<CardClass>>(
              stream: bloc.gameFieldSubject,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return SizedBox.shrink();
                }
                List<CardClass> listOfCards = snapshot.data!;
                return _ReorderableWrapWidget(
                    listOfCards: listOfCards, intGridType: intGridType);
              });
        });
  }
}

class _ReorderableWrapWidget extends StatefulWidget {
  final int intGridType;
  final List<CardClass> listOfCards;

  const _ReorderableWrapWidget(
      {super.key, required this.listOfCards, required this.intGridType});

  @override
  State<_ReorderableWrapWidget> createState() => _ReorderableWrapWidgetState();
}

class _ReorderableWrapWidgetState extends State<_ReorderableWrapWidget> {

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
    return ReorderableWrap(
        enableReorder: _isEnableReorderableWrap,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        spacing: _listOfGridValues[widget.intGridType].crossAxisSpacing,
        runSpacing: _listOfGridValues[widget.intGridType].mainAxisSpacing,
        children: List.generate(widget.listOfCards.length, (index) {
          return AnimatedFlipWrapper(
              key: ValueKey<String>(widget.listOfCards[index].id),
              card: widget.listOfCards[index],
              cardSize: _listOfGridValues[widget.intGridType].cardSize,
              imagePadding: _listOfGridValues[widget.intGridType].imagePadding);
        }),
        onReorder: ((oldIndex, newIndex) {
          final item = widget.listOfCards.removeAt(oldIndex);
          widget.listOfCards.insert(newIndex, item);
          bloc.gameFieldSubject.add(widget.listOfCards);
        }));
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

class AnimatedFlipWrapper extends StatefulWidget {
  final CardClass card;
  final bool imagePadding;
  final Size cardSize;

  const AnimatedFlipWrapper(
      {super.key, required this.card, required this.imagePadding, required this.cardSize});

  @override
  State<AnimatedFlipWrapper> createState() => _AnimatedFlipWrapperState();
}

class _AnimatedFlipWrapperState extends State<AnimatedFlipWrapper> {
  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of<Bloc>(context, listen: false);
    final CardClass card = widget.card;

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
      cardFace:
          FaceCardWidget(size: widget.cardSize, imagePadding: widget.imagePadding),
      isFace: (card.isFace || _isEnableReorderableWrap),
      onTap: () async {
        if (!card.isGuessed && !card.isFace) {

          addToBloc(bloc: bloc);
        }
      },
    );
  }

  void addToBloc({required Bloc bloc}) async {
    bloc.playerSelectedCardSubject.add(widget.card.flipCard());
  }
}

class AnimatedFlip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        tween: Tween<double>(
            begin: _isEnableReorderableWrap ? 0 : 180, end: isFace ? 0 : 180),
        builder: (context, value, child) {
          final content = value < 90
              ? cardBack
              : RotationY(rotationY: 180, child: cardFace);

          return RotationY(rotationY: value, child: content);
        },
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import '../bloc/main_bloc.dart';
import '../models/card_class.dart';
import '../sources/app_colors.dart';
import '../sources/app_images.dart';

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
          await Future.delayed(Duration(milliseconds: 505));
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        bool _isEnableDragAndDrop = state.isEnableDragAndDrop;

        return GestureDetector(
          onTap: widget.onTap,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            tween: Tween<double>(
              begin: _isEnableDragAndDrop ? 0 : 180,
              end: widget.isFace ? 0 : 180,
            ),
            builder: (context, value, child) {
              final content = value < 90
                  ? widget.cardBack
                  : RotationY(child: widget.cardFace, rotationY: 180);
              return RotationY(rotationY: value, child: content);
            },
          ),
        );
      },
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

// Tween<double>(
// begin: _isEnableDragAndDrop ? 0 : 180,
// end: widget.isFace ? 0 : 180),
// builder: (context, value, child) {
// final content = value < 90
// ? widget.cardBack
//     : RotationY(rotationY: 180, child: widget.cardFace);
//
// return RotationY(rotationY: value, child: content);
// },

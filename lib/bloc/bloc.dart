import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../models/card_class.dart';
import '../sources/app_images.dart';
import '../sources/grid_values.dart';

class Bloc {
  BehaviorSubject<int> gameLevelSubject = BehaviorSubject.seeded(1);
  BehaviorSubject<List<CardClass>> gameFieldSubject = BehaviorSubject();
  BehaviorSubject<GameState> gameStateSubject =
      BehaviorSubject.seeded(GameState.none);

  BehaviorSubject<List<String>> listStringFormattedPlayingDate =
      BehaviorSubject();
  BehaviorSubject<List<String>> playerStatisticsSubject =
      BehaviorSubject();
  BehaviorSubject<String> stringLevelContainerSubject = BehaviorSubject();
  BehaviorSubject<CardClass> playerSelectedCardSubject = BehaviorSubject();

  BehaviorSubject<List<double>> progressBarStateListSubject =
      BehaviorSubject.seeded([1, 10]);

  BehaviorSubject<bool> isGoOnNextLevelSubject = BehaviorSubject.seeded(false);
  BehaviorSubject<int> gridTypeSubject = BehaviorSubject.seeded(0);

  late final StreamSubscription<GameState> _gameStateSubscription;
  late final StreamSubscription<CardClass> _playerActionSubscription;

  Bloc() {
    _gameStateSubscription = gameStateSubject.listen((gameState) {
      if (gameState == GameState.start) {
        restartStatistics();
        startGame();
      }
    });
    _playerActionSubscription = playerSelectedCardSubject.listen((card) {
      card.flipCard();
      addSelectedCard(card);
    });
  }


  int maxLevel = 1;

  void startGame() {
    resetAllValues();
    gameFieldSubject
        .add(generateMemoFieldList(difficulty: gameLevelSubject.value));
    updateStringLevelContainerSubject();
    gameStateSubject.add(GameState.game);
    startTimer();
  }

  void resetAllValues() {
    gameLevelSubject.add(1);
    gridTypeSubject.add(0);
    progressBarStateListSubject
        .add([gameLevelSubject.value.toDouble(), maxLevel.toDouble()]);
  }

  void updateStringLevelContainerSubject() {
    int currentLevel = gameLevelSubject.value;
    String result = 'q$currentLevel/$maxLevel';
    stringLevelContainerSubject.add(result);
  }

  void nextLevel() async {
    int nextLevel = gameLevelSubject.value + 1;
    progressBarStateListSubject
        .add([nextLevel.toDouble(), maxLevel.toDouble()]);
    gameStateSubject.add(GameState.newLevel);
    gameLevelSubject.add(nextLevel);
    checkIsWin();
    await Future.delayed(Duration(milliseconds: 300));
    if (gameStateSubject.value != GameState.win) {
      updateStringLevelContainerSubject();
      if (nextLevel < 4) {
        gridTypeSubject.add(gridTypeSubject.value += 1);
        gameFieldSubject.add(generateMemoFieldList(difficulty: nextLevel));
      } else {
        gameFieldSubject.add(generateMemoFieldList(difficulty: 4));
      }
    }
  }

  void checkIsWin() {
    int currentLevel = gameLevelSubject.value;
    if (currentLevel > maxLevel) {
      stopTimer();
      playerStatisticsSubject.add(getPlayerStatistics());
      listStringFormattedPlayingDate.add(getFormattedPlayingTime());
      gameStateSubject.add(GameState.win);
    }
  }

  List<CardClass> generateMemoFieldList({required int difficulty}) {
    int elementCount = 6 * difficulty;
    if (elementCount % 2 != 0) {
      elementCount -= 1;
    }
    List<CardClass> result = [];
    for (int i = 0; i < elementCount ~/ 2; i++) {
      result.add(CardClass(content: imagePathsList[i]));
      result.add(CardClass(content: imagePathsList[i]));
    }
    result.shuffle();
    return result;
  }

  //Реализация логики memo
  List<CardClass> listOfSelectedCard = [];
  BehaviorSubject<bool> isWaitingSubject = BehaviorSubject.seeded(false);

  void addSelectedCard(CardClass card, ) {
    _playerMoves++;
    listOfSelectedCard.add(card);
    if (listOfSelectedCard.length == 2) {
      comparingCard();
    }
  }

  void comparingCard() async {
    bool areAllCardsEqual = listOfSelectedCard
        .every((card) => card.content == listOfSelectedCard[0].content);
    if (!areAllCardsEqual) {
      List<CardClass> gameField = gameFieldSubject.value;
      isWaitingSubject.add(true);
      await Future.delayed(Duration(seconds: 1));
      for (final selectedCard in listOfSelectedCard) {
        final index = gameField.indexOf(selectedCard);
        if (index != -1) {
          gameField[index].flipCard();
        }
      }
    } else {
      for (final selectedCard in listOfSelectedCard) {
        selectedCard.setGuessed();

        checkIsAllCardIsGuess();
      }
    }
    listOfSelectedCard.clear();
    gameFieldSubject.add(gameFieldSubject.value);
    // Для завершения анимации
    await Future.delayed(Duration(milliseconds: 300));

    isWaitingSubject.add(false);
  }

  void checkIsAllCardIsGuess() async {
    List<CardClass> listOfCards = gameFieldSubject.value;
    int countOfGuessedCard = 0;
    for (var card in listOfCards) {
      if (card.isGuessed) countOfGuessedCard++;
    }
    if (countOfGuessedCard == listOfCards.length) {
      await Future.delayed(Duration(seconds: 1));
      List<CardClass> gameField = gameFieldSubject.value;
      gameField.forEach((card) {
        card.flipCard();
      });
      gameFieldSubject.add(gameFieldSubject.value);

      nextLevel();
    }
  }

  //Statistics

  int _playerMoves = 0;

  void restartStatistics(){
    _playerMoves = 0;
  }

  late DateTime startTimeDate;
  late DateTime stopTimeDate;

  void startTimer() {
    startTimeDate = DateTime.now();
  }

  void stopTimer() {
    stopTimeDate = DateTime.now();
  }

  List<String> getPlayerStatistics(){
    final int playerMoves = _playerMoves ~/2;
    return ['Moves: $playerMoves'];
  }

  List<String> getFormattedPlayingTime() {
    Duration difference = stopTimeDate.difference(startTimeDate);

    int totalSeconds = difference.inSeconds.abs();

    int hours = totalSeconds ~/ 3600;
    int remainingSeconds = totalSeconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    // Формируем строку результата
    return ["Hours: $hours", "Minutes: $minutes", "Seconds: $seconds"];
  }

  List<String> imagePathsList = [
    AppImages.christTheRedeemer,
    AppImages.stonehenge,
    AppImages.stPaulsCathedral,
    AppImages.neuschwansteinCastle,
    AppImages.eiffelTower,
    AppImages.colosseum,
    AppImages.pyramids,
    AppImages.bigBen,
    AppImages.tajMahal,
    AppImages.statueOfLiberty,
    AppImages.sydneyOperaHouse,
    AppImages.saintBasilsCathedral,
  ];

  dispose() {
    _gameStateSubscription.cancel();
    _playerActionSubscription.cancel();

    gameLevelSubject.close();
    gameFieldSubject.close();
    gameStateSubject.close();
    stringLevelContainerSubject.close();
    playerSelectedCardSubject.close();
    progressBarStateListSubject.close();
    isGoOnNextLevelSubject.close();
    gridTypeSubject.close();
    isWaitingSubject.close();
  }
}

enum GameState { none, start, game, pause, newLevel, win }

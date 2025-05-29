import 'dart:async';
import 'package:memo/models/memo_class.dart';
import 'package:rxdart/rxdart.dart';
import '../models/card_class.dart';

class Blocc {
  BehaviorSubject<int> gameLevelSubject = BehaviorSubject.seeded(1);
  BehaviorSubject<List<CardClass>> gameFieldSubject = BehaviorSubject();
  BehaviorSubject<GameState> gameStateSubject =
      BehaviorSubject.seeded(GameState.none);



  BehaviorSubject<List<String>> listStringFormattedPlayingDate =
      BehaviorSubject();
  BehaviorSubject<List<String>> playerStatisticsSubject = BehaviorSubject();
  BehaviorSubject<String> stringLevelContainerSubject = BehaviorSubject();
  BehaviorSubject<CardClass> playerSelectedCardSubject = BehaviorSubject();

  BehaviorSubject<List<double>> progressBarStateListSubject =
      BehaviorSubject.seeded([1, 10]);

  BehaviorSubject<bool> isGoOnNextLevelSubject = BehaviorSubject.seeded(false);
  BehaviorSubject<int> gridTypeSubject = BehaviorSubject.seeded(0);

  late final StreamSubscription<GameState> _gameStateSubscription;
  late final StreamSubscription<CardClass> _playerActionSubscription;

  final MemoClass memo = MemoClass();

  Blocc() {
    _gameStateSubscription = gameStateSubject.listen((gameState) {
      if (gameState == GameState.start) {
        restartStatistics();
        startGame();
      }
      if(gameState == GameState.win){
        winGame();
      }
      if(gameState == GameState.newLevel){
        nextLevel();
      }
    });
    _playerActionSubscription = playerSelectedCardSubject.listen((card) {
      CardClass updateCard = flipCard(card);

      addSelectedCard(updateCard);
    });
  }

  int maxLevel = 5;

  void startGame() {
    resetAllValues();
    gameFieldSubject
        .add(memo.generateFieldList(difficulty: gameLevelSubject.value));
    updateStringLevelContainerSubject();
    gameStateSubject.add(GameState.game);
    startTimer();
  }


  void winGame(){
    stopTimer();
    listStringFormattedPlayingDate.add(getFormattedPlayingTime());
    playerStatisticsSubject.add(getPlayerStatistics());
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
    gameLevelSubject.add(nextLevel);

    if (nextLevel <= maxLevel) {
      updateStringLevelContainerSubject();
      await Future.delayed(Duration(seconds: 1));
      if (nextLevel < 4) {
        gridTypeSubject.add(gridTypeSubject.value += 1);
        gameFieldSubject.add(memo.generateFieldList(difficulty: nextLevel));
      } else {
        gameFieldSubject.add(memo.generateFieldList(difficulty: 4));
      }
    } else {
      gameStateSubject.add(GameState.win);
    }
  }

  List<CardClass> listOfSelectedCard = [];
  BehaviorSubject<bool> isWaitingSubject = BehaviorSubject.seeded(false);

  void addSelectedCard(
    CardClass card,
  ) async {
    _playerMoves++;
    await Future.delayed(Duration(seconds: 1));
    listOfSelectedCard.add(card);
    if (listOfSelectedCard.length == 2) {
      List<CardClass> gameField = memo.comparingCardAndGetNewField(
        listOfSelectedCards: listOfSelectedCard,
        gameField: gameFieldSubject.value,
      );
      listOfSelectedCard.clear();

      gameFieldSubject.add(gameField);

      checkIsNextLevel();
    }

  }

  void checkIsNextLevel() {
    if (memo.isNextLevel(gameField: gameFieldSubject.value)) {
      gameStateSubject.add(GameState.newLevel);
    }
  }

  CardClass flipCard(CardClass card) {
    CardClass updatedCard = card;
    List<CardClass> gameField = gameFieldSubject.value;
    gameField = gameField.map((currentCard) {
      if (currentCard.id == card.id) {
        updatedCard = currentCard.flipCard();
        return updatedCard;
      }
      return currentCard;
    }).toList();
    print('flip: $updatedCard');
    gameFieldSubject.add(gameField);
    return updatedCard;
  }

  //Statistics

  int _playerMoves = 0;

  void restartStatistics() {
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

  List<String> getPlayerStatistics() {
    final int playerMoves = _playerMoves ~/ 2;
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

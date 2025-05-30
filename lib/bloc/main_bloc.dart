import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memo/models/memo_class.dart';

import '../enums/page_type.dart';
import '../models/card_class.dart';
import '../models/statistics_class.dart';

part 'main_event.dart';

part 'main_state.dart';

part 'main_bloc.freezed.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState.initial()) {
    on<MainEvent>((event, emit) async {
      await event.map(
        openGamePage: (event) => _onOpenGamePage(emit),
        addCard: (event) => _onAddCard(event.selectedCard, emit),
        startNextLevel: (event) => _onStartNextLevel(emit),
        pauseGame: (event) => _onPauseGame(emit),
        updateGameFieldByGrid: (event) =>
            _onUpdateGameFieldByGrid(event.gameField),
        restartGame: (event) => _onRestartGame(emit),
        checkIsCompareOrNextLevel: (event) =>
            _onCheckIsCompareOrNextLevel(emit),
        tapOnDragAndDropButton: (event) => _onTapDragAndDropButton(emit),
      );
    });
  }

  List<CardClass> savedGameField = [];


  final MemoClass memo = MemoClass();
  final Statistics statistics = Statistics();

  FutureOr<void> _onOpenGamePage(Emitter<MainState> emit) async {
    PageType currentPageType = state.pageType;
    if (currentPageType == PageType.start) {
      _startGame();
    }
    emit(state.copyWith(pageType: PageType.game));
  }

  FutureOr<void> _onAddCard(CardClass selectedCard,
      Emitter<MainState> emit,) async {
    if (state.listOfSelectedCards.length < 2) {
      statistics.addMove();
      selectedCard = selectedCard.flipCard();
      List<CardClass> gameField = state.gameField.map((currentCard) {
        if (currentCard.id == selectedCard.id) {
          return selectedCard;
        }
        return currentCard;
      }).toList();
      emit(state.copyWith(
        listOfSelectedCards: [...state.listOfSelectedCards, selectedCard],
        gameField: gameField,
      ));
    }
  }

  FutureOr<void> _onStartNextLevel(Emitter<MainState> emit) {
    int nextLevel = state.level + 1;
    late List<CardClass> newGameField;
    late int newGridIndex;
    if (nextLevel < 4) {
      newGridIndex = state.gridTypeIndex + 1;
      newGameField = memo.generateFieldList(difficulty: nextLevel);
    } else {
      newGridIndex = state.gridTypeIndex + 1;
      newGameField = memo.generateFieldList(difficulty: 4);
    }
    emit(state.copyWith(
        gridTypeIndex: newGridIndex,
        gameField: newGameField,
        level: nextLevel,
        pageType: PageType.game));
  }

  FutureOr<void> _onCheckIsCompareOrNextLevel(Emitter<MainState> emit) {
    //здесь проверка на след экран или переворот карт
    if (state.listOfSelectedCards.length == 2) {
      List<CardClass> gameField = memo.comparingCardAndGetNewField(
        listOfSelectedCards: state.listOfSelectedCards,
        gameField: state.gameField,
      );
      if (memo.isNextLevel(gameField: gameField)) {
        if (state.level == state.maxLevel) {
          winGame();
        } else {
          emit(state
              .copyWith(pageType: PageType.nextLevel, listOfSelectedCards: []));
        }
      } else {
        emit(state.copyWith(gameField: gameField, listOfSelectedCards: []));
      }
    }
  }

  FutureOr<void> _onPauseGame(Emitter<MainState> emit) async {
    emit(state.copyWith(pageType: PageType.pause));
  }

  void _startGame() async {
    statistics.resetAllDate();
    List<CardClass> newGameField = memo.generateFieldList(difficulty: 1);
    statistics.setStartTimeDate();
    emit(state.copyWith(
      level: 1,
      gameField: newGameField,
      playerTimeStatistics: [],
      playerGameStatistics: [],
      gridTypeIndex: 0,
    ));
  }

  FutureOr<void> _onUpdateGameFieldByGrid(List<CardClass> newGameField) async {
    emit(state.copyWith(gameField: newGameField));
  }

  void winGame() {
    statistics.setStopTimeDate();
    emit(state.copyWith(pageType: PageType.win, playerTimeStatistics: statistics.getFormattedPlayingTime(), playerGameStatistics: statistics.getFormattedPlayerStatistics(), listOfSelectedCards: []));
  }

  FutureOr<void> _onRestartGame(Emitter<MainState> emit) {
    emit(state.copyWith(pageType: PageType.start));
  }

  FutureOr<void> _onTapDragAndDropButton(Emitter emit) {
    bool newStatusEnable = !state.isEnableDragAndDrop;

    if (newStatusEnable) {
      savedGameField = List.from(state.gameField);
      List<CardClass> flippedGameField = state.gameField.map((card) {
        if (!card.isFace) {
          return card.flipCard();
        }
        return card;
      }).toList();
      emit(state.copyWith(
          isEnableDragAndDrop: newStatusEnable, gameField: flippedGameField));
    } else {
      //Здесь возвращаем старые развороты
      late List<CardClass> newGameField = List.from(state.gameField);
      for (CardClass card in savedGameField) {
        newGameField = newGameField.map((currentCard) {
          if (card.id == currentCard.id) {
            return card;
          }
          return currentCard;
        }).toList();
      }
      emit(state.copyWith(isEnableDragAndDrop: !state.isEnableDragAndDrop, gameField: newGameField));

    }
  }




}

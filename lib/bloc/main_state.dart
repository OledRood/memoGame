part of 'main_bloc.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    required int level,
    required int maxLevel,
    required List<CardClass> gameField,
    required int gridTypeIndex,
    required PageType pageType,
    required List<String> playerTimeStatistics,
    required List<String> playerGameStatistics,
    required List<CardClass> listOfSelectedCards,
    required bool isEnableDragAndDrop,
  }) = _MainState;

  factory MainState.initial() => MainState(
        level: 1,
        gameField: [],
        maxLevel: 3,
        gridTypeIndex: 0,
        pageType: PageType.start,
        playerTimeStatistics: [],
        playerGameStatistics: [],
        listOfSelectedCards: [],
        isEnableDragAndDrop: false,
      );
}

part of 'main_bloc.dart';

@freezed
class MainEvent with _$MainEvent {
  const factory MainEvent.openGamePage() = _GamePageOpened;
  const factory MainEvent.addCard(CardClass selectedCard) = _CardAdded;
  const factory MainEvent.startNextLevel() = _NextLevelStarted;
  const factory MainEvent.restartGame() = _gameRestarted;
  const factory MainEvent.pauseGame() = _GamePaused;
  const factory MainEvent.checkIsCompareOrNextLevel() = _CompareOrNextLevelChecked;
  const factory MainEvent.updateGameFieldByGrid(List<CardClass> gameField) = _GameFieldUpdated;
  const factory MainEvent.tapOnDragAndDropButton() = _DragAndDropButtonTapped;



}

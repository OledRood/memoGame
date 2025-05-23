import 'package:uuid/uuid.dart';

import '../bloc/bloc.dart';
import '../sources/app_images.dart';
import 'card_class.dart';

class MemoClass {
  List<CardClass> generateFieldList({required int difficulty}) {
    final Uuid uuid = Uuid();

    int elementCount = 6 * difficulty;
    if (elementCount % 2 != 0) {
      elementCount -= 1;
    }
    List<CardClass> result = [];
    for (int index = 0; index < elementCount ~/ 2; index++) {
      result.add(CardClass(content: _imagePathsList[index], id: uuid.v4()));
      result.add(CardClass(content: _imagePathsList[index], id: uuid.v4()));
    }
    result.shuffle();
    return result;
  }

// [newField, GameState]
  List<CardClass> comparingCardAndGetNewField(
      {required List<CardClass> listOfSelectedCards,
      required List<CardClass> gameField})  {
    bool areAllCardsEqual = listOfSelectedCards
        .every((card) => card.content == listOfSelectedCards[0].content);
    if (!areAllCardsEqual) {
      for (final selectedCard in listOfSelectedCards) {
        gameField = gameField.map((cardInGameField) {
          if (cardInGameField.id == selectedCard.id) {
            return selectedCard.flipCard();
          }

          return cardInGameField;
        }).toList();
      }

      return gameField;
    } else {
      for (final selectedCard in listOfSelectedCards) {
        gameField = gameField.map((cardInGameField) {
          if (cardInGameField.id == selectedCard.id) {
            return selectedCard.markAsGuessed();
          }
          return cardInGameField;
        }).toList();
      }
      return gameField;
    }
  }

  bool isNextLevel({required List<CardClass> gameField}) {
    int guessedCount = 0;
    for (final card in gameField) {
      if (card.isGuessed) {
        guessedCount++;
      }
    }
    if (guessedCount == gameField.length) {
      return true;
    }
    return false;
  }

  List<String> _imagePathsList = [
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
}

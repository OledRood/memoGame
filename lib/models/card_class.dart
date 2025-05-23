import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_class.freezed.dart';
@freezed
class CardClass with _$CardClass{
const CardClass._();

const factory CardClass({
  required String content,
  required String id,
  @Default(false) bool isFace,
  @Default(false) bool isGuessed,
}) = _CardClass;

  CardClass flipCard(){
    return copyWith(isFace: !isFace);
  }

  CardClass markAsGuessed(){
    return copyWith(isGuessed: true);
  }

}
//flutter pub run build_runner build


// class CardClass {
//   final String content;
//   bool isFront;
//   bool isGuessed = false;
//   CardClass({required this.content, this.isFront = false});
//
//   void setGuessed() {
//     isGuessed = true;
//   }
//
//   void flipCard() {
//     isFront = !isFront;
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is CardClass &&
//           runtimeType == other.runtimeType &&
//           content == other.content &&
//           isFront == other.isFront;
//
//   @override
//   int get hashCode => content.hashCode ^ isFront.hashCode;
// }

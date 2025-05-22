class CardClass {
  final String content;
  bool isFront;
  bool isGuessed = false;
  CardClass({required this.content, this.isFront = false});

  void setGuessed() {
    isGuessed = true;
  }

  void flipCard() {
    isFront = !isFront;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardClass &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          isFront == other.isFront;

  @override
  int get hashCode => content.hashCode ^ isFront.hashCode;
}

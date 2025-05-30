class Statistics{
  Statistics();

  DateTime? _startTimeDate;
  DateTime? _stopTimeDate;
  int _moves = 0;

  void setStartTimeDate(){
    _startTimeDate = DateTime.now();
  }
  void setStopTimeDate (){
    _stopTimeDate = DateTime.now();
  }
  void resetAllDate(){
    _startTimeDate = null;
    _stopTimeDate = null;
    _moves = 0;
  }
  void addMove(){
    _moves++;
  }

  List<String> getFormattedPlayingTime() {
    if(_stopTimeDate == null || _stopTimeDate == null){
      throw ArgumentError('Оба поля _stopTimeDate должны быть заполнены!');
    }
    Duration difference = _stopTimeDate!.difference(_startTimeDate!);

    int totalSeconds = difference.inSeconds.abs();

    int hours = totalSeconds ~/ 3600;
    int remainingSeconds = totalSeconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    // Формируем строку результата
    return ["Hours: $hours", "Minutes: $minutes", "Seconds: $seconds"];
  }

  List<String> getFormattedPlayerStatistics() {
    final int playerMoves = _moves ~/ 2;
    return ['Moves: $playerMoves'];
  }
  }
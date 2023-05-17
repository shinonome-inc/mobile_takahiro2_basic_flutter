import 'dart:io';
import 'dart:math';

// 手の種類を定義する列挙型
enum Hand {
  Rock,
  Paper,
  Scissors,
}

//自分の手を入力して取得する
Hand getPlayerHand() {
  while (true) {
    stdout.write('Please enter your hand (Rock/Paper/Scissors): ');
    final input = stdin.readLineSync()?.toLowerCase();
    if (input == 'rock') {
      return Hand.Rock;
    } else if (input == 'paper') {
      return Hand.Paper;
    } else if (input == 'scissors') {
      return Hand.Scissors;
    } else {
      print('Invalid input. Please enter Rock, Paper, or Scissors.');
    }
  }
}
  //コンピュータの手をランダムに生成
  Hand getRandomHand(){
    final random = Random();
    final hands = Hand.values;
    return hands[random.nextInt(hands.length)];
  }

  //勝敗を決定させる
  String judge(Hand playerHand,Hand commputerHand){
    if(playerHand==commputerHand){
      return 'Draw';
    }else if(playerHand==Hand.Rock&&commputerHand==Hand.Scissors||
        playerHand==Hand.Scissors&&commputerHand==Hand.Paper||
        playerHand==Hand.Paper&&commputerHand==Hand.Rock){
      return 'Win';
    } else{
      return 'Lose';
    }
  }

  void main(){
    //コンピュータの手をランダムに決定
    final commputerHand = getRandomHand();
    //プレイヤーの手をランダムに決定
    final playerHand = getPlayerHand();
    //勝敗を決定する
    final result = judge(playerHand,commputerHand);
    print('You chose ${playerHand.toString().split('.').last}.');
    print('The computer chose ${commputerHand.toString().split('.').last}.');
    print(result);
  }
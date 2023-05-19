import 'dart:io';
import 'dart:math';

// 手の種類を定義する列挙型
enum Hand {
  rock,
  paper,
  scissors,
}

//自分の手を入力して取得する
Hand getPlayerHand() {
  while (true) {
    stdout.write('Please enter your hand (rock/paper/scissors): ');
    final input = stdin.readLineSync()?.toLowerCase();
    if (input == 'rock') {
      return Hand.rock;
    } else if (input == 'paper') {
      return Hand.paper;
    } else if (input == 'scissors') {
      return Hand.scissors;
    } else {
      print('Invalid input. Please enter Rock, Paper, or Scissors.');
    }
  }
}
//コンピュータの手をランダムに生成
Hand getRandomHand(){
  final random = Random();
  const hands = Hand.values;
  return hands[random.nextInt(hands.length)];
}

//勝敗を決定させる
String judge(Hand playerHand,Hand commputerHand){
  if(playerHand==commputerHand){
    return 'Draw';
  }else if(playerHand==Hand.rock&&commputerHand==Hand.scissors||
      playerHand==Hand.scissors&&commputerHand==Hand.paper||
      playerHand==Hand.paper&&commputerHand==Hand.rock){
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

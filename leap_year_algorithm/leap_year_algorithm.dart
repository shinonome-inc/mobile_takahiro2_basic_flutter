import 'dart:io';
bool isLeapYear(int year) {
  if (year % 4 == 0) {
    if (year % 100 == 0) {
      if (year % 400 == 0) {
        return true; // 400で割り切れる年は閏年
      } else {
        return false; // 100で割り切れて、400で割り切れない年は平年
      }
    } else {
      return true; // 4で割り切れる年は閏年
    }
  } else {
    return false; // 4で割り切れない年平年
  }
}
void main(List<String> arguments) {
  stdout.write('Please input a year:');
  int input = int.parse(stdin.readLineSync()!);
  if(isLeapYear(input)){
    stdout.write("isLeapYear(year: $input)//True");
  }else{
    stdout.write("isLeapYear(year: $input)//False");
  }
}


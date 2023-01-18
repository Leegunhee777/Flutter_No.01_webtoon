import 'package:flutter/material.dart';
import 'package:webtoon/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //이 위젯의 key를 stateless Widget이라는 슈퍼클래스에 보내는 것이다.
  //위젯은 ID같은 식별자 역할을 하는 key가 있다는 것이다.
  //flutter 가 위젯을 빠르게 찾을수 있게 말이다.
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

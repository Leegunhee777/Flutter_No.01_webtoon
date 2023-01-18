//st를 적으면 자동 완성을 사용할수 있다.
import 'package:flutter/material.dart';
import 'package:webtoon/model/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  //클래스 안에 Future를 사용하면 해당 클래스는 const일수가 없음
  //const는 컴파일전에 값을 알고있다는것인데, Future타입과 상충되기 때문이다.
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "오늘의 웹툰",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      //FutureBuilder에는 builder라는 매개변수가 필요하다.
      //builder는 UI를 그려주는 함수이다.
      //FutureBuilder에게 webtoons 값을 받아올때까지 기다려달라고 할수있음!!!
      // future 속성에 webtoons 값을 부여하면
      // FutureBuilder가 알아서 내부적으로 await를 걸어준다.

      //builder의 매개변수로 받을수있는 매개변수에 대해 설명해주겠다.
      //context: 기존의 위젯클래스에서의 build함수에서 받을수있는 BuildContext context과 같은역할
      //snapshot을 이용하면 Future의 상태를 알수있다.
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      separatorBuilder: ((context, index) {
                        return const SizedBox(
                          width: 40,
                        );
                      }),
                      //ListView.builder는 사용자가 보고 있는 아이템만 build 한다.
                      //사용자가 안보고있는 데이터는, 메모리에서 삭제된다.
                      //itemBuilder는 ListView.builder가
                      //아이템을 build 할떄마다 호출하는 함수이다.
                      //인덱스인자를 통해 어떤 아이템이 build 되는지 알수있다.
                      itemBuilder: (context, index) {
                        var webtoon = snapshot.data![index];
                        return Webtoon(
                          title: webtoon.title,
                          thumb: webtoon.thumb,
                          id: webtoon.id,
                        );
                      }),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

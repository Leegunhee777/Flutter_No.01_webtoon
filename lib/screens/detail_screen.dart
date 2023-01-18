import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/model/webtoon_detail_model.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

//state클래스에서 StatefulsWidget클래스에있는 멤버변수에 적급하기위해선
//widget에라는 키워드를 사용해야 접근가능하다
class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  //initPrefs 함수는 Future 타입을 반환해야하므로, await를 적어줘야함
  //좋아요 초기화!!!를 위한 로직
  Future<void> initPrefs() async {
    //SharedPreferences 를 사용하기 위한 Instance
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');

    if (isLiked) {
      likedToons!.remove(widget.id);
    } else {
      likedToons!.add(widget.id);
    }
    await prefs.setStringList('likedToons', likedToons);
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        //foregroundColor로 Navigator.push시 생성되는 Nav아이콘 컬러 정해줄수있음
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.4),
                          )
                        ],
                      ),
                      //clipBehavior: 자식의 부모영역 침범을 제어하는 방법
                      //이걸적용해야 borderRadius가 올바르게 적용된다.
                      clipBehavior: Clip.hardEdge,
                      //url을 통해 이미지를 로드할때 쓰는 위젯!
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: webtoon,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('...');
                }),
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                  }
                  return const Text('...');
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:webtoon/model/webtoon_detail_model.dart';
// import 'package:webtoon/services/api_service.dart';

// class DetailScreen extends StatelessWidget {
//   String title, thumb, id;
//   DetailScreen({
//     super.key,
//     required this.title,
//     required this.thumb,
//     required this.id,
//   });

//   final Future<WebtoonDetailModel> webtoons = ApiService.getToonById(id);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         //foregroundColor로 Navigator.push시 생성되는 Nav아이콘 컬러 정해줄수있음
//         foregroundColor: Colors.white,
//         elevation: 3,
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Hero(
//                 tag: id,
//                 child: Container(
//                   width: 250,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 15,
//                         offset: const Offset(10, 10),
//                         color: Colors.black.withOpacity(0.4),
//                       )
//                     ],
//                   ),
//                   //clipBehavior: 자식의 부모영역 침범을 제어하는 방법
//                   //이걸적용해야 borderRadius가 올바르게 적용된다.
//                   clipBehavior: Clip.hardEdge,
//                   //url을 통해 이미지를 로드할때 쓰는 위젯!
//                   child: Image.network(thumb),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

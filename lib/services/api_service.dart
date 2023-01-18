import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/model/webtoon_detail_model.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';
import 'package:webtoon/model/webtoon_model.dart';

class ApiService {
  static String baseUrl = 'https://webtoon-crawler.nomadcoders.workers.dev';
  static String today = "today";

  //async 함수는 항상 Future타입을 반환해야한다.
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];

    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //서버로부터의 응답인 JSON문자열을 파싱하기위해서
      //jsonDecode 함수를 이용한다.

      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromjson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}

/*
http 요청을 보내기 위해서는
http 패키지를 설치해야한다.
Flutter나 Dart 패키지를 찾고 싶으면
pub.dev라는 Dart,Flutter 공식 패키지 보관소로 가면된다.
Node의 npm 이나 Python의 PyPI같은 곳이다.

설치할수있는 방법은 여러가지가 있다.
1)
커맨드에
flutter pub add http
명령어를 통해 해당 패키지를 설치할수있다. 

2)
dart pub add http
명령어를 통해 해당 패키지를 설치할수있다.

3)
dependencies:
  http: ^0.13.5 
위의 텍스트를
flutter create로 만든 프로젝트의 pubspec.yaml(야믈)이라는
파일(프로젝트에 대한 정보와 설정이 담긴 파일이다.)에 붙여넣는 방법이있다.
붙여넣고 저장한뒤에 .yaml파일에서의 download 버튼을 누르면
해당 패키지가 설치된다.

future 타입은 현재가 아닌 미래에 받을 결과 값의 타입을 알려주는 것이다.
당장 완료될수있는 작업, 데이터가 아니라는것을 말해준다.
미래에 완료되었을때 이 함수가 Response(서버에 대한 정보가 담겨있을 거라는 뜻)를 
반환할거라는 것을 알수있다.
*/

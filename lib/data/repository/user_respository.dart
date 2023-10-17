// 데이터의 요청 : View -> Provider(전역 프로바이더, 뷰모델) -> Repository
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';

/// 통신 - 파싱
class UserRepository {
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    // ★ 통신은 무조건 try 해야 한다.
    // dio는 200 외에 내부적으로 터져서 try-catch 해야한다.
    try {
      final response = await dio.post("/join", data: requestDTO.toJson());

      // join이 되었음을 알리는 응답 데이터(=join 데이터)
      // 응답은 model을 참조하자.

      // 1. 파싱 : response 데이터를 reponseDTO에 담기 = responseDTO 타입은 dynamic이라 없다.
      // int -> 1, String -> 성공, dynamic -> Map타입
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      // 2. 파싱 : dynamice 타입인 Map을 User 타입으로 한 번 더 파싱
      // int -> 1, String -> 성공, Map -> User
      responseDTO.data = User.fromJson(responseDTO.data);
      // 3. user 객체를 Dart 오브젝트 타입으로 변경
      return responseDTO;
      // 정상응답이면 1
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    try {
      final response = await dio.post("/login", data: requestDTO.toJson());
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);

      // 토큰 세션값 변경을 위해 response의 헤더의 jwt를 가져와서 등록하기
      final jwt = response.headers["Authorization"];
      if (jwt != null) {
        responseDTO.token = jwt.first; // = jwt[0]
      }

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "유저 혹은 비밀번호가 틀렸습니다.", null);
    }
  }
}

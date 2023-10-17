// 데이터의 요청 : View -> Provider(전역 프로바이더, 뷰모델) -> Repository
import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/model/user.dart';

/// 통신 - 파싱
class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      /// 1. 통신
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));
      // header의 token을 전달해야하므로, option을 넣는다.
      // 토큰은 sessionProvider가 가지고 있으므로, ref를 통해 접근이 가능하다.
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      /// 2. ResponseDTO 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;

      /// 3. ResponseDTO의 data 파싱
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      /// 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
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

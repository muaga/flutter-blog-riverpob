import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_respository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 통신 성공 또는 실패

// 1. 창고 데이터
class SessionUser {
  // 1. 화면 context에 접근하는 법(화면 이동 가능)
  // 글로벌key를 설정해 놓았기 때문에 가능하다.
  final mContext = navigatorKey.currentContext;

  User? user;
  String? jwt;
  bool isLogin; // jwt의 존재보다 유효에 따른 true/false

  SessionUser({this.user, this.jwt, this.isLogin = false});

  /// 2. 통신의 상태코드로 나눈다.
  Future<void> join(JoinReqDTO joinReqDTO) async {
    // 1. 통신 코드

    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);
    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> login(LoginReqDTO loginReqDTO) async {
    // 1. 통신 코드

    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);
    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      // 1) 세션값 갱신 : 로그인이 성공하면, 창고 데이터 갱신
      // this.user = responseDTO.data as User;
      this.user = responseDTO.data as User;
      this.jwt = responseDTO.token;
      this.isLogin = true;

      // 2) 디바이스에 JWT 저장 : 자동로그인
      await secureStorage.write(key: "jwt", value: responseDTO.token);
      // await를 통해 jwt를 저장하는 것인데, 이건 통신이라서 await를 달아서 통신이 완료 시
      // 다음 코드가 진행되도록 한다.

      // 3. 페이지 이동
      Navigator.pushNamed(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> logout() async {
    /// jwt와 isLogin 상태 변경
    this.jwt = null;
    this.isLogin = false;
    this.user = null;

    /// secureStorage(자동로그인) 삭제
    await secureStorage.delete(key: "jwt"); // IO

    /// 페이지 이동
    Navigator.pushNamedAndRemoveUntil(mContext!, "/login", (route) => false);
    // route이름으로 이동 후 그 이전 모두 삭제(로그아웃)
    // false -> 이전 목록 삭제, true -> 이전 목록 저장
  }
}

// 2. 창고 관리자
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});

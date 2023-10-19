import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 모든 파라미터가 들어오는 provider

/// 1. 창고 데이터
class RequestParam {
  int? postDetailId;
  // int? commentId;

  RequestParam({this.postDetailId});
}

/// 2. 창고(비즈니스 로직)
class ParamStore extends RequestParam {
  final mContext = navigatorKey.currentContext; // 화면이동을 위해 mContext를 가진다.

  void addPostDetailId(int postId) {
    this.postDetailId = postId;
  } // 생략가능
}

/// 3. 창고 관리자
final paramProvider = Provider<ParamStore>((ref) {
  return ParamStore();
});

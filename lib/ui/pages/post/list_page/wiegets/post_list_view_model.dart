// view-model에서 응답받는 데이터의 타입이 1개의 객체인 지 List인 지 잘 알아야 한다.

import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. 창고 데이터
class PostListModel {
  List<Post> posts;

  PostListModel(this.posts);
}

/// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref); // super._state = PostListModel 타입

  Ref ref;

  // state값이 변경되면 re-build가 되도록 알린다.
  void notifyInit() async {
    // jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }
}

/// 3. 창고 관리자(view가 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
  // ..notifyInit() : 언젠가 null -> 상태가 들어오면 변경이 될 것이다.
});

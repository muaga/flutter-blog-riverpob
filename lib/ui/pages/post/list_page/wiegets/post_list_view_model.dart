// view-model에서 응답받는 데이터의 타입이 1개의 객체인 지 List인 지 잘 알아야 한다.

import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_respository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// 1. 창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel({required this.posts});
}

/// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref); // super._state = PostListModel 타입

  final mContext = navigatorKey.currentContext;
  Ref ref;

  // state값이 변경되면 re-build가 되도록 알린다.
  void notifyInit() async {
    // jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(posts: responseDTO.data);
  }

  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().savePost(sessionUser.jwt!, dto);
    // fetchSave할 때, token과 body데이터를 넘겨줘야 한다.

    if (responseDTO.code == 1) {
      /// dynamic(post) -> 다운 캐스팅
      Post newPost = responseDTO.data as Post;
      List<Post> posts = state!.posts;

      /// 상태값 추가(List 추가)
      List<Post> newPosts = [newPost, ...posts];

      /// 뷰모델(창고) 상태 갱신 완료 -> 구독자(postListPage)는 자동 갱신
      state = PostListModel(posts: newPosts);

      /// 해당 페이지 삭제
      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.msg}")));
    }
  }
}

/// 3. 창고 관리자(view가 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
  // ..notifyInit() : 언젠가 null -> 상태가 들어오면 변경이 될 것이다.
});

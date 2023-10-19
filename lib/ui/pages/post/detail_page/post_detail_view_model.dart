import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/param_provider.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// selected post
// 여기에 넣는 것은..... 기존에 통신했었던 List<Post>에서 가져오느냐, 통신을 하느냐에 나뉜다.
/// 창고 데이터
class PostDetailModel {
  Post post;
  PostDetailModel(this.post);
}

/// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  // selected는 이미 통신으로 끝난 List<post>라서, "?"가 없어도 될 듯 하다.
  PostDetailViewModel(super._state, this.ref);
  Ref ref;

  Future<void> notifyInit(int id) async {
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, id);

    state = PostDetailModel(responseDTO.data);
  }
}

/// 창고 관리자
final postDetailProvider =
    StateNotifierProvider.autoDispose<PostDetailViewModel, PostDetailModel?>(
        (ref) {
  int postId = ref.read(paramProvider).postDetailId!; // null일 수 없다.
  Logger().d("postId : ${postId}");
  return PostDetailViewModel(null, ref)..notifyInit(postId);
});

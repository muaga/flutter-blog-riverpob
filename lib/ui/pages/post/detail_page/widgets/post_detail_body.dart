import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_view_model.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  const PostDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 3: watch ? read ?
    // read/watch : provider의 상태값에 바로 접근이 가능하다.
    PostDetailModel? model = ref.watch(postDetailProvider);
    // PostDetailModel? pdm2 = ref.watch(postDetailProvider);
    // notifier : 창고에 접근
    // ref.read(postDetailProvider.notifier);

    if (model == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      Post post = model!.post; // 절대 바뀔리 없어서 !

      // if(model == null){} <= 이건 통신일 때만, 왜냐하면 이미 통신으로 받은 데이터이기 때문에
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PostDetailTitle(post.title),
            const SizedBox(height: largeGap),
            PostDetailProfile(),
            PostDetailButtons(),
            const Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent("${context}"),
          ],
        ),
      );
    }
  }
}

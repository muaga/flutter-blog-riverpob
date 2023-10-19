import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_body.dart';

class PostDetailPage extends StatelessWidget {
  PostDetailPage({Key? key}) : super(key: key);

  /// post의 내용이 필요한 body에서 provider와 연결을 한다. 여기서는 연결할 필요가 없음
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostDetailBody(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_view_model.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
            funValidator: validateTitle(),
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            funValidator: validateContent(),
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글쓰기",
            // 글을 쓰면 postListviewmodel의 상태를 바꿀 것이다.
            // 그래서 postListviewmodel을 새로 만들 필요 없고, 기존 view 모델에 접근해야 한다.
            funPageRoute: () async {
              if (_formKey.currentState!.validate()) {
                Logger().d("title : ${_title.text}");
                Logger().d("content : ${_content.text}");
                PostSaveReqDTO dto =
                    PostSaveReqDTO(title: _title.text, content: _content.text);
                ref.read(postListProvider.notifier).notifyAdd(dto);
              }
            },
          ),
        ],
      ),
    );
  }
}

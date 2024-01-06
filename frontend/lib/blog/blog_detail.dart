import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'widgets/detail_layout.dart';

class BlogDetail extends StatelessWidget {
  final String articleId;
  final bool edit;

  const BlogDetail(this.articleId, {super.key, this.edit = false});

  @override
  @override
  Widget build(BuildContext context) {
    return ArticleDetailLayout(
      articleId: int.tryParse(articleId),
      child: (detail, layout) {
        final currentUser = context.read<AuthProvider>().user;
        final article = detail.article;
        final owner = detail.owner;

        if (article == null) {
          if (detail.isLoading) return loadingView();
          if (detail.hasError) return errorView(message: detail.errorMessage);
          return const SizedBox.shrink();
        }

        const footerStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
        final isPostOwner = currentUser != null && owner != null && currentUser.id == owner.id;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PageHeader(
                title: Text(article.title, style: const TextStyle(color: Colors.black)),
                commandBar: CommandBar(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  primaryItems: [
                    if (isPostOwner)
                      CommandBarButton(
                        icon: const Icon(FluentIcons.edit),
                        label: const Text('Edit'),
                        onPressed: () => router.pushReplacement('/posts/${article.id}/edit'),
                      ),
                  ],
                ),
                padding: 0,
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.05)))),
                padding: const EdgeInsets.only(top: 16),
                child: MarkdownWidget(data: article.description),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.5))),
                ),
                child: Row(
                  children: [
                    Text('Last updated ${timeago.format(article.updatedAt)}', style: footerStyle),
                    const Spacer(),
                    if (owner != null) Text('Posted by: ${owner.name}', style: footerStyle)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

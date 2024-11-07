import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'widgets/article_base_layout.dart';

class BlogDetail extends StatelessWidget {
  final String articleId;

  const BlogDetail(this.articleId, {super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return ArticleBaseLayout(
      articleId: int.tryParse(articleId),
      child: (detail, layout) {
        final currentUser = context.read<AuthProvider>().user;
        final articleProv = context.read<ArticleProvider>();

        final article = detail.article;
        final owner = detail.owner;

        if (article == null) {
          if (detail.isLoading) return loadingView();
          if (detail.hasError) return errorView(message: detail.errorMessage);
          return const SizedBox.shrink();
        }

        const footerStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
        final isPostOwner = currentUser != null && owner != null && currentUser.id == owner.id;
        final imageUri = article.imageUrl ?? defaultArticleImage;

        final imageHost = Uri.tryParse(imageUri)?.host;
        const spacing = SizedBox(height: 24);

        return Column(
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
                  if (isPostOwner)
                    CommandBarButton(
                      icon: Icon(FluentIcons.delete, color: Colors.red),
                      label: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: const Text('Delete Blog permanently?'),
                                content: const Text(
                                  'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
                                ),
                                actions: [
                                  FilledButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(Colors.red),
                                        shape: WidgetStateProperty.all(
                                          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                        )),
                                    onPressed: () async {
                                      await articleProv
                                          .deleteArticle(int.tryParse(articleId)!)
                                          .then((value) => router.pushReplacement('/'));
                                    },
                                    child: const Text("Delete"),
                                  ),
                                  FilledButton(
                                    style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                                    onPressed: () => router.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                ],
              ),
              padding: 0,
            ),
            Divider(
              style: DividerThemeData(
                thickness: 0.2,
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.05)))),
              ),
            ),
            spacing,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  height: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: imageView(imageUri)),
                      if (imageHost != null) ...[
                        const SizedBox(height: 8),
                        Text(imageHost, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 350),
                    alignment: Alignment.topRight,
                    child: MarkdownWidget(data: article.description, shrinkWrap: true),
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: Row(
                children: [
                  Text('Last Updated: ${timeago.format(article.updatedAt)}', style: footerStyle),
                  const Spacer(),
                  if (owner != null) Text('Author: ${owner.name}', style: footerStyle)
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

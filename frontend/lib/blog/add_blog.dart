import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/blog/add_layout.dart';
import 'package:frontend/data/models/article.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';
import 'package:frontend/utils/provider.dart';
import 'package:provider/provider.dart';

const _spacing = SizedBox(height: 24);

class AddBlogPage extends StatefulWidget {
  final int? articleId;
  const AddBlogPage({super.key, this.articleId});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  String? title;
  String? description;
  String? imageUrl;
  Article? article;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.articleId != null) {
      article = context.read<ArticleProvider>().lastEvent?.data?.firstWhereOrNull(
          (element) => widget.articleId != null && element.id == widget.articleId);
      if (article != null) {
        _titleController.text = article!.title;
        _descriptionController.text = article!.description;
        _imageController.text = article!.imageUrl ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return BaseAddLayout(
      child: (articleProv, layout) {
        registerAction(String title, String description, String? imageUrl) async {
          layout.setLoading(true);
          if (article == null) {
            await articleProv.addArticle(title, description, imageUrl);
          } else {
            await articleProv.updateArticle(article!.id, title, description, imageUrl);
          }

          layout
            ..setLoading(false)
            ..handleErrors(articleProv.lastEvent!);
          if (mounted && articleProv.lastEvent!.state == ProviderState.success) {
            router.pop();
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.articleId == null ? "New Post" : "Edit Post",
              style: typography.bodyStrong!.copyWith(color: blogColor, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            InfoLabel(
                label: 'Blog Title',
                child: TextBox(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() => title = value.trim()))),
            _spacing,
            InfoLabel(
              label: 'Description',
              child: TextBox(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => setState(() => description = value),
                maxLines: null,
                minLines: 5,
              ),
            ),
            _spacing,
            InfoLabel(
                label: 'Image Url (Optional)',
                child: TextBox(
                    controller: _imageController,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() => imageUrl = value.trim()))),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                FilledButton(
                  style: ButtonStyle(
                    shape: ButtonState.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                  onPressed: [title, description].contains(null)
                      ? null
                      : () => registerAction(title!, description!, imageUrl),
                  child: Text(widget.articleId == null ? 'Add Post' : 'Update Post'),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

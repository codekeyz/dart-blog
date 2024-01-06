import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/blog/widgets/article_base_layout.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';
import 'package:frontend/utils/provider.dart';
import 'package:provider/provider.dart';

const _spacing = SizedBox(height: 24);

class ArticleFormView extends StatefulWidget {
  final String? articleId;
  const ArticleFormView({super.key, this.articleId});

  @override
  State<ArticleFormView> createState() => _ArticleFormViewState();
}

class _ArticleFormViewState extends State<ArticleFormView> {
  String? title;
  String? description;
  String? imageUrl;

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  bool hasSetDefaults = false;

  int? articleId;

  @override
  void initState() {
    super.initState();

    if (widget.articleId != null) {
      articleId = int.tryParse(widget.articleId!);
      if (articleId == null) router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return ArticleBaseLayout(
      articleId: articleId,
      child: (detailProv, layout) {
        final articleProv = context.read<ArticleProvider>();
        final maybeArticle = detailProv.article;

        if (maybeArticle != null && !hasSetDefaults) {
          _titleCtrl.text = maybeArticle.title;
          _descriptionCtrl.text = maybeArticle.description;
          _imageUrlCtrl.text = maybeArticle.imageUrl ?? '';
        }

        createOrUpdateAction(String title, String description, String? imageUrl) async {
          layout.setLoading(true);

          if (widget.articleId != null && maybeArticle != null) {
            await articleProv.updateArticle(maybeArticle.id, title, description, imageUrl);
          } else if (widget.articleId == null) {
            await articleProv.addArticle(title, description, imageUrl);
          }

          layout.setLoading(false);

          if (articleProv.hasError) {
            layout.handleErrors(ProviderEvent.error(errorMessage: articleProv.errorMessage!));
            return;
          }

          router.pushReplacement('/');
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
                    controller: _titleCtrl,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() => title = value.trim()))),
            _spacing,
            InfoLabel(
              label: 'Description',
              child: TextBox(
                controller: _descriptionCtrl,
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
                    controller: _imageUrlCtrl,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() => imageUrl = value.trim()))),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                FilledButton(
                  style: ButtonStyle(
                    shape: ButtonState.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                  onPressed: [title, description].contains(null)
                      ? null
                      : () => createOrUpdateAction(title!, description!, imageUrl),
                  child: Text(widget.articleId == null ? 'Add Post' : 'Update Post'),
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _imageUrlCtrl.dispose();
  }
}

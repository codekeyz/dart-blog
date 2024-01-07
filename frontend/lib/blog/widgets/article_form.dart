import 'package:appflowy_editor/appflowy_editor.dart';
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
  final _titleCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  bool hasSetDefaults = false;

  int? articleId;

  EditorState? editorState;

  bool get isValidPost => _titleCtrl.text.trim().isNotEmpty && editorState != null && !editorState!.document.isEmpty;

  @override
  void initState() {
    super.initState();

    if (widget.articleId != null) {
      articleId = int.tryParse(widget.articleId!);
      if (articleId == null) router.pop();
    }
    if (widget.articleId == null) editorState = EditorState.blank();
  }

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return ArticleBaseLayout(
      articleId: articleId,
      child: (detailProv, layout) {
        final articleProv = context.read<ArticleProvider>();
        final maybeArticle = detailProv.article;

        if (articleId != null && maybeArticle == null) {
          if (detailProv.isLoading) return loadingView();
          if (detailProv.hasError) {
            layout.handleErrors(ProviderEvent.error(errorMessage: detailProv.errorMessage!));
            router.pop();
            return const SizedBox.shrink();
          }
        }

        if (maybeArticle != null && !hasSetDefaults) {
          _titleCtrl.text = maybeArticle.title;
          editorState = EditorState(document: markdownToDocument(maybeArticle.description));
          final imageUrl = maybeArticle.imageUrl;
          if (imageUrl != null) _imageUrlCtrl.text = imageUrl;
        }

        createOrUpdateAction() async {
          if (!isValidPost) {
            layout.handleErrors(const ProviderEvent.error(errorMessage: 'Post is not valid'));
            return;
          }

          final title = _titleCtrl.text.trim();
          final description = documentToMarkdown(editorState!.document);
          final imageUrl = Uri.tryParse(_imageUrlCtrl.text)?.toString();

          layout.setLoading(true);

          if (maybeArticle != null) {
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

        if (editorState == null) return loadingView();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: Text(maybeArticle != null ? 'Update Post' : 'New Post'),
              padding: 0,
            ),
            _spacing,
            InfoLabel(
              label: 'Title',
              labelStyle: const TextStyle(fontWeight: FontWeight.w300),
              child: TextBox(
                controller: _titleCtrl,
                keyboardType: TextInputType.text,
                autofocus: true,
                placeholder: 'Post Title',
                style: typography.bodyLarge!.copyWith(color: blogColor),
              ),
            ),
            const SizedBox(height: 32),
            InfoLabel(label: 'Write your post'),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              width: double.maxFinite,
              child: Card(
                borderColor: blogColor.withOpacity(0.1),
                borderRadius: BorderRadius.zero,
                child: AppFlowyEditor(
                  shrinkWrap: true,
                  editorStyle: EditorStyle.desktop(
                      padding: EdgeInsets.zero, selectionColor: Colors.grey.withOpacity(0.5), cursorColor: blogColor),
                  editorState: editorState!,
                ),
              ),
            ),
            _spacing,
            InfoLabel(
              label: 'Image Url',
              labelStyle: const TextStyle(fontWeight: FontWeight.w300),
              child: TextBox(controller: _imageUrlCtrl, keyboardType: TextInputType.url),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                FilledButton(
                  style: ButtonStyle(
                      shape: ButtonState.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                  onPressed: createOrUpdateAction,
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
    _imageUrlCtrl.dispose();
  }
}

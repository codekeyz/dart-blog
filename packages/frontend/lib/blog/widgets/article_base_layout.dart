import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/blog/blog.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/main.dart';

import 'package:frontend/utils/provider.dart';
import 'package:shared/models.dart';

import '../../utils/misc.dart';

class ArticleBaseLayout extends StatefulWidget {
  final int? articleId;

  final Widget Function(ArticleDetailLoader detailProv, ArticleBaseLayoutState layout) child;

  const ArticleBaseLayout({this.articleId, super.key, required this.child});

  @override
  State<ArticleBaseLayout> createState() => ArticleBaseLayoutState();
}

class ArticleBaseLayoutState extends State<ArticleBaseLayout> {
  final _detailProvider = ArticleDetailLoader();

  bool _showingLoading = false;

  @override
  void initState() {
    super.initState();

    final id = widget.articleId;
    if (id != null) _detailProvider.fetchArticle(id);
  }

  @override
  Widget build(BuildContext context) {
    return WebConstrainedLayout(
      child: StreamBuilder<ProviderEvent<ArticleWithAuthor>>(
        stream: _detailProvider.stream,
        initialData: _detailProvider.lastEvent,
        builder: (_, __) => ScaffoldPage.scrollable(
          children: [
            if (_showingLoading) const SizedBox(width: double.maxFinite, child: ProgressBar()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
              child: widget.child(_detailProvider, this),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _detailProvider.dispose();
  }

  void setLoading(bool show) => setState(() => _showingLoading = show);

  void handleErrors(ProviderEvent<Article> event) {
    if (event.state != ProviderState.error) return;
    showError(context, event.errorMessage!);
  }
}

class ArticleDetailLoader extends BaseProvider<ArticleWithAuthor> {
  ApiService get apiSvc => getIt.get<ApiService>();

  Article? get article => lastEvent?.data?.article;

  User? get owner => lastEvent?.data?.author;

  Future<void> fetchArticle(int articleId) async {
    final result = await safeRun(() => apiSvc.getArticle(articleId));
    if (result == null) return;

    addEvent(ProviderEvent.success(data: result));
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/models/article.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/services.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/provider.dart';

import '../../utils/misc.dart';

class ArticleDetailLayout extends StatefulWidget {
  final int? articleId;

  final Widget Function(ArticleDetailLoader detailProv, ArticleDetailLayoutState layout) child;

  const ArticleDetailLayout({required this.articleId, super.key, required this.child});

  @override
  State<ArticleDetailLayout> createState() => ArticleDetailLayoutState();
}

class ArticleDetailLayoutState extends State<ArticleDetailLayout> {
  final _detailProvider = ArticleDetailLoader();

  bool _showingLoading = false;

  @override
  void initState() {
    super.initState();

    final id = widget.articleId;
    if (id == null) {
      router.pushReplacement('/');
      return;
    }

    _detailProvider.fetchArticle(id);
  }

  @override
  Widget build(BuildContext context) {
    final pageWith = MediaQuery.of(context).size.width;
    final widthToUse = pageWith <= 400 ? pageWith * 0.9 : pageWith * 0.7;

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Stack(
        children: [
          acrylicBackground,
          Center(
            child: SizedBox(
              width: widthToUse.toDouble(),
              child: StreamBuilder<ProviderEvent<Article>>(
                stream: _detailProvider.stream,
                initialData: _detailProvider.lastEvent,
                builder: (context, snapshot) {
                  return Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_showingLoading) const SizedBox(width: double.maxFinite, child: ProgressBar()),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                          child: widget.child(_detailProvider, this),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLoading(bool show) => setState(() => _showingLoading = show);

  void handleErrors(ProviderEvent<Article> event) {
    if (event.state != ProviderState.error) return;
    showError(context, event.errorMessage!);
  }
}

class ArticleDetailLoader extends BaseProvider<Article> {
  ApiService get apiSvc => getIt.get<ApiService>();

  Article? get article => lastEvent?.data;

  User? _user;

  User? get owner => _user;

  Future<void> fetchArticle(int articleId) async {
    final result = await safeRun(() => apiSvc.getArticle(articleId));
    if (result == null) return;

    addEvent(ProviderEvent.success(data: result));

    await _fetchOwner(result.ownerId);
  }

  Future<void> _fetchOwner(int ownerId) async {
    try {
      _user = await apiSvc.getUserById(ownerId);
      addEvent(ProviderEvent.success(data: article!));
    } catch (_) {}
  }
}

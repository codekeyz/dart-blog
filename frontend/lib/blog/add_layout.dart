import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/models/article.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/utils/misc.dart';
import 'package:frontend/utils/provider.dart';
import 'package:provider/provider.dart';

class BaseAddLayout extends StatefulWidget {
  final Widget Function(ArticleProvider blog, BaseAddLayoutState layout) child;

  const BaseAddLayout({super.key, required this.child});

  @override
  State<BaseAddLayout> createState() => BaseAddLayoutState();
}

class BaseAddLayoutState extends State<BaseAddLayout> {
  bool _showingLoading = false;

  @override
  Widget build(BuildContext context) {
    final blogProv = context.read<ArticleProvider>();
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showingLoading) const SizedBox(width: double.maxFinite, child: ProgressBar()),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: widget.child(blogProv, this),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setLoading(bool show) => setState(() => _showingLoading = show);

  void handleErrors(ProviderEvent<List<Article>> event) {
    if (event.state != ProviderState.error) return;
    showError(context, event.errorMessage!);
  }
}

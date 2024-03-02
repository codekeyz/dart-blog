import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:frontend/utils/misc.dart';
import 'package:provider/provider.dart';

import 'widgets/article_items.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late AuthProvider _authProvider;
  late ArticleProvider _articleProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = context.read();
    _articleProvider = context.read();

    _fetchData();
  }

  void _fetchData() async {
    await Future.wait([
      _authProvider.getUser(),
      _articleProvider.fetchArticles(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WebConstrainedLayout(
      child: ScaffoldPage.scrollable(children: const [BlogArticlesWidget()]),
    );
  }
}

class WebConstrainedLayout extends StatelessWidget {
  final Widget child;
  const WebConstrainedLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: blogColor.withOpacity(0.1));

    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1300),
        decoration: BoxDecoration(border: Border(left: borderSide, right: borderSide, top: borderSide)),
        margin: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

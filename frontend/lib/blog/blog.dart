import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/article_items.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = context.read();
    Future.microtask(_authProvider.getUser);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      padding: const EdgeInsets.all(12),
      children: const [BlogArticlesWidget()],
    );
  }
}

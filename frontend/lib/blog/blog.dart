import 'package:fluent_ui/fluent_ui.dart';

import 'widgets/article_items.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      padding: EdgeInsets.zero,
      children: const [BlogArticlesWidget()],
    );
  }
}

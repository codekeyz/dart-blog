import 'package:fluent_ui/fluent_ui.dart';

import 'article_card.dart';

class BlogArticlesWidget extends StatelessWidget {
  const BlogArticlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: const Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: [
          ArticleCard(),
          ArticleCard(),
          ArticleCard(),
          ArticleCard(),
          ArticleCard(),
        ],
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/blog/widgets/add_article_card.dart';
import 'package:frontend/data/providers/article_provider.dart';
import 'package:frontend/utils/misc.dart';
import 'package:frontend/utils/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared/models.dart';

import 'article_card.dart';

class BlogArticlesWidget extends StatelessWidget {
  const BlogArticlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    final articleProv = context.read<ArticleProvider>();

    return StreamBuilder<ProviderEvent<List<Article>>>(
      stream: articleProv.stream,
      initialData: articleProv.lastEvent,
      builder: (context, snapshot) {
        final articles = snapshot.data?.data ?? [];
        final state = snapshot.data?.state;
        final loading = state == ProviderState.loading;

        if (articles.isEmpty) {
          if (loading) return loadingView();
          if (state == ProviderState.error) return errorView();
        }

        return Wrap(
          runSpacing: spacing,
          spacing: spacing,
          alignment: WrapAlignment.start,
          children: [const AddArticleCard(), ...articles.map((e) => ArticleCard(e))],
        );
      },
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/models/article.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return SizedBox(
      width: 300,
      height: 250,
      child: Card(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: GestureDetector(
          onTap: () => router.push('/posts/${article.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null) ...[
                Expanded(child: imageView(article.imageUrl!)),
              ] else
                Container(color: blogColor.withOpacity(0.1), height: 100),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: typography.bodyStrong!.copyWith(color: blogColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                style: typography.bodyLarge!.copyWith(color: blogColor, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

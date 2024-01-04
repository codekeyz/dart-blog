import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/utils/misc.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return SizedBox(
      width: 250,
      child: Card(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Image.network(
                  'https://images.unsplash.com/photo-1704303928271-775bb222ab46?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Some blog post',
                style: typography.bodyStrong!.copyWith(color: blogColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Some blog post asfjaklsdjfl ajdlfjlsjdflkajkldf asdfjaklsdjflka asdfjakdjf aljdfkaj dfl',
                style: typography.bodyLarge!.copyWith(color: blogColor, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

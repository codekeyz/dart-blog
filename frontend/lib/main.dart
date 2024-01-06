import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:frontend/blog/blog_detail.dart';
import 'package:frontend/data/services.dart';
import 'package:frontend/blog/blog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth/auth.dart';
import 'utils/misc.dart';

import 'data/providers/auth_provider.dart';
import 'data/providers/article_provider.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => const BlogPage()),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage(), name: 'login'),
    GoRoute(path: '/register', builder: (_, __) => const RegisterPage(), name: 'register'),
    GoRoute(path: '/posts/:postId', builder: (_, state) => BlogDetail(state.pathParameters['postId'] ?? '')),
    GoRoute(
        path: '/posts/:postId/edit',
        builder: (_, state) => BlogDetail(state.pathParameters['postId'] ?? '', edit: true)),
  ],
);

void main() {
  setupServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ArticleProvider>(create: (_) => ArticleProvider()),
      ],
      child: FluentApp.router(
        routerConfig: router,
        title: 'Dart Blog 🚀',
        debugShowCheckedModeBanner: false,
        color: blogColor,
        theme: FluentThemeData.light(),
        builder: (_, child) => _AppLayout(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}

class _AppLayout extends StatelessWidget {
  final Widget child;

  const _AppLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FluentTheme(
          data: FluentThemeData.dark(),
          child: Container(
            decoration: const BoxDecoration(color: blogColor),
            padding: const EdgeInsets.only(top: 12),
            alignment: Alignment.center,
            child: PageHeader(
              title: GestureDetector(
                onTap: () => router.pushReplacement('/'),
                child: Row(
                  children: [
                    Image.asset('imgs/yaroo.png', width: 24, height: 24),
                    const SizedBox(width: 10),
                    const Text('Dart Blog', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              commandBar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const AuthHeaderOptions(),
                  const SizedBox(width: 24),
                  Tooltip(
                    message: 'View on Github',
                    displayHorizontally: true,
                    useMousePosition: false,
                    style: const TooltipThemeData(preferBelow: true),
                    child: IconButton(
                      icon: const Icon(FluentIcons.graph_symbol, size: 24.0),
                      onPressed: () => launchUrl(Uri.parse(projectUrl)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

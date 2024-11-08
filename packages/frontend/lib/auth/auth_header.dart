import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared/models.dart';

class AuthHeaderOptions extends StatelessWidget {
  const AuthHeaderOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    const spacing = SizedBox(width: 24);

    return StreamBuilder<ProviderEvent<User>>(
      stream: auth.stream,
      initialData: auth.lastEvent,
      builder: (context, snapshot) {
        final user = auth.user;
        final isLoading = snapshot.data?.state == ProviderState.loading;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isLoading && user == null) ...[
              Button(child: const Text('Login '), onPressed: () => router.push('/login')),
              spacing,
              Button(child: const Text('Register'), onPressed: () => router.push('/register')),
            ],
            if (user != null) ...[
              Text('Welcome, ${user.name.split(' ').first}'),
              spacing,
              Button(
                child: const Text('Logout'),
                onPressed: () {
                  auth.logout();
                  router.pushReplacement('/');
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

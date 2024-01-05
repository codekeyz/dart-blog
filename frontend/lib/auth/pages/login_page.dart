import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';

import 'base_layout.dart';

const _spacing = SizedBox(height: 18);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    final themeData = FluentTheme.of(context);
    return BaseAuthLayout(
      child: (state) {
        final auth = context.read<AuthProvider>();

        loginAction(String email, String password) async {
          state.setLoading(true);
          await auth.login(email, password);
          state.setLoading(false);

          final user = auth.lastEvent?.data;
          if (user != null) router.pushReplacement('/');
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'Email',
              child: TextBox(onChanged: (value) => setState(() => email = value)),
            ),
            _spacing,
            InfoLabel(
              label: 'Password',
              child: PasswordBox(onChanged: (value) => setState(() => password = value)),
            ),
            _spacing,
            Text.rich(
              TextSpan(
                text: 'No account? ',
                children: <InlineSpan>[
                  TextSpan(
                      text: 'Create one!', style: themeData.typography.body?.apply(color: themeData.accentColor.dark)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                FilledButton(
                  style: ButtonStyle(
                    shape: ButtonState.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                  onPressed: [email, password].contains(null) ? null : () => loginAction(email!, password!),
                  child: const Text('Sign in'),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

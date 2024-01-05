import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/data/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'base_layout.dart';

const _spacing = SizedBox(height: 24);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? name;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      child: (state) {
        final auth = context.read<AuthProvider>();

        registerAction(String name, String email, String password) async {
          state.setLoading(true);
          await auth.register(name, email, password);
          state.setLoading(false);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoLabel(
                label: 'Display Name',
                child: TextBox(
                    keyboardType: TextInputType.name, onChanged: (value) => setState(() => name = value.trim()))),
            _spacing,
            InfoLabel(
                label: 'Email',
                child: TextBox(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => email = value.trim()))),
            _spacing,
            InfoLabel(label: 'Password', child: PasswordBox(onChanged: (value) => setState(() => password = value))),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                FilledButton(
                  style: ButtonStyle(
                    shape: ButtonState.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                  onPressed:
                      [name, email, password].contains(null) ? null : () => registerAction(name!, email!, password!),
                  child: const Text('Register'),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

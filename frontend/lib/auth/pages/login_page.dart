import 'package:fluent_ui/fluent_ui.dart';

import 'base_layout.dart';

const _spacing = SizedBox(height: 18);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = FluentTheme.of(context);
    return BaseAuthLayout(
      child: (state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(label: 'Email', child: const TextBox()),
          _spacing,
          InfoLabel(label: 'Password', child: const PasswordBox()),
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
                onPressed: () {},
                child: const Text('Sign in'),
              )
            ],
          )
        ],
      ),
    );
  }
}

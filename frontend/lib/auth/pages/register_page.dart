import 'package:fluent_ui/fluent_ui.dart';

import 'base_layout.dart';

const _spacing = SizedBox(height: 24);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      child: (state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InfoLabel(label: 'Display Name', child: const TextBox(keyboardType: TextInputType.name)),
          _spacing,
          InfoLabel(label: 'Email', child: const TextBox(keyboardType: TextInputType.emailAddress)),
          _spacing,
          InfoLabel(label: 'Password', child: const PasswordBox()),
          const SizedBox(height: 28),
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              FilledButton(
                style: ButtonStyle(
                  shape: ButtonState.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                ),
                onPressed: () {},
                child: const Text('Register'),
              )
            ],
          )
        ],
      ),
    );
  }
}

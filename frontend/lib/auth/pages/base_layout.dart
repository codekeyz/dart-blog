import 'package:fluent_ui/fluent_ui.dart';

const _spacing = SizedBox(height: 24);

class BaseAuthLayout extends StatefulWidget {
  final Widget Function(BaseAuthLayoutState state) child;

  const BaseAuthLayout({super.key, required this.child});

  @override
  State<BaseAuthLayout> createState() => BaseAuthLayoutState();
}

class BaseAuthLayoutState extends State<BaseAuthLayout> {
  bool _showingLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Center(
        child: SizedBox(
          width: 320,
          child: Card(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showingLoading) const SizedBox(width: double.maxFinite, child: ProgressBar()),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: widget.child(this),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setLoading(bool show) => setState(() => _showingLoading = show);
}

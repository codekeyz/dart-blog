import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:fluent_ui/fluent_ui.dart';

const projectUrl = 'https://github.com/codekeyz/dart-blog';

const blogColor = Color(0xff1c2834);

void showError(BuildContext context, String error) => CherryToast.error(
      title: Text(
        error,
        style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 12, color: Colors.white),
      ),
      toastPosition: Position.bottom,
      autoDismiss: true,
      borderRadius: 0,
      backgroundColor: blogColor,
      shadowColor: Colors.transparent,
      toastDuration: const Duration(seconds: 5),
      displayCloseButton: false,
      iconWidget: const Icon(FluentIcons.error, color: Colors.white),
    ).show(context);

const acrylicBackground = Card(
  padding: EdgeInsets.zero,
  child: SizedBox(
    height: double.maxFinite,
    width: double.maxFinite,
    child: Acrylic(tint: blogColor),
  ),
);

loadingView({String message = 'loading, please wait...'}) => Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProgressRing(),
          const SizedBox(height: 24),
          Text(message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
        ],
      ),
    );

errorView({String? message}) {
  message ??= 'Oops!, an error occurred';
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(FluentIcons.error),
        const SizedBox(height: 24),
        Text(message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
      ],
    ),
  );
}

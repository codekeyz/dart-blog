import 'dart:math' as math;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/misc.dart';

class AddArticleCard extends StatelessWidget {
  const AddArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DottedBorder();
  }
}

class DottedBorder extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  const DottedBorder(
      {super.key, this.color = Colors.black, this.strokeWidth = 1.5, this.gap = 5.0});

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return Padding(
      padding: EdgeInsets.all(strokeWidth / 2),
      child: GestureDetector(
        onTap: () {
          router.push('/addBlog');
        },
        child: CustomPaint(
            painter: DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
            child: SizedBox(
              width: 200,
              height: 200,
              child: Card(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Center(
                  child: Text(
                    "Add Blog +",
                    style: typography.bodyStrong!.copyWith(color: blogColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter({this.strokeWidth = 5.0, this.color = Colors.black, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path topPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path leftPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0 ? math.cos(radians) * gap * -1 : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0 ? math.sin(radians) * gap * -1 : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(
              double.parse(currentPoint.x.toString()), double.parse(currentPoint.y.toString()))
          : path.moveTo(
              double.parse(currentPoint.x.toString()), double.parse(currentPoint.y.toString()));
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

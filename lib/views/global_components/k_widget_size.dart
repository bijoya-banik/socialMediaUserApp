import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class KWidgetSize extends StatefulWidget {
  final Widget? child;
  final Function? onChange;

  const KWidgetSize({@required this.onChange, @required this.child, Key? key}) : super(key: key);

  @override
  _KWidgetSizeState createState() => _KWidgetSizeState();
}

class _KWidgetSizeState extends State<KWidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange!(newSize);
  }
}

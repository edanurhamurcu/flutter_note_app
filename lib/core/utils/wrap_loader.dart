import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/loader_overlay.dart';

class WrapLoader extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const WrapLoader({super.key, required this.child, required this.onRefresh});

  @override
  _WrapLoaderState createState() => _WrapLoaderState();
}

class _WrapLoaderState extends State<WrapLoader> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.atEdge &&
            scrollNotification.metrics.pixels == 0) {
          _handleRefresh();
        }
        return false;
      },
      child: widget.child,
    );
  }

  Future<void> _handleRefresh() async {
    LoaderOverlay().show(context);
    await widget.onRefresh();
    LoaderOverlay().hide();
  }
}

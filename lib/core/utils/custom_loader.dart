import 'package:flutter/material.dart';

class CustomWrapLoader extends StatefulWidget {
  final Color color;
  final double size;
  final int count;
  final double speed;

  const CustomWrapLoader({
    super.key,
    this.color = Colors.blue,
    this.size = 20.0,
    this.count = 5,
    this.speed = 1.0,
  });

  @override
  _CustomWrapLoaderState createState() => _CustomWrapLoaderState();
}

class _CustomWrapLoaderState extends State<CustomWrapLoader> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.size * 2.5,
        width: widget.size * 2.5,
        child: CircularProgressIndicator(
          value: _controller.value,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
      ),
    );
  }
}
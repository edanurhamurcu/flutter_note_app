import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoaderOverlay {
  static final LoaderOverlay _singleton = LoaderOverlay._internal();

  factory LoaderOverlay() {
    return _singleton;
  }

  LoaderOverlay._internal();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    // Hide the keyboard if it is open
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  void hide({Duration minDuration = const Duration(seconds: 1)}) {
    if (!_isShowing) return;

    Future.delayed(minDuration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isShowing = false;
    });
  }
}

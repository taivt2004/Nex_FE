// ignore_for_file: cascade_invocations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexpaylab/share/ui/loading/loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen.instance() => _shared;
  LoadingScreen._shareInstance();
  static final LoadingScreen _shared = LoadingScreen._shareInstance();

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String text = 'Loading',
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textController = StreamController<String>();
    textController.add(text);
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * .8,
              maxHeight: size.width * .8,
              minWidth: size.width * .5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: textController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.requireData,
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        textController.add(text);
        return true;
      },
    );
  }
}

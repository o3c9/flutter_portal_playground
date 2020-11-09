import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Portal(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
              appBar: AppBar(title: const Text('test')),
              body: Center(child: ClapButton())),
        ),
      ),
    );
  }
}

final countProvider = StateProvider<int>((_) => 0);
final visibleProvider = StateProvider<bool>((_) => false);
final timerProvider = StateProvider<Timer>((_) => null);

class ClapButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final countController = useProvider(countProvider);
    final count = countController.state;

    final visibleController = useProvider(visibleProvider);
    final visible = visibleController.state;

    final timerController = useProvider(timerProvider);
    final timer = timerController.state;

    return PortalEntry(
        visible: visible,
        childAnchor: Alignment.topCenter,
        portalAnchor: Alignment.bottomCenter,
        closeDuration: kThemeChangeDuration,
        child: RaisedButton(
            onPressed: () {
              timer?.cancel();
              timerController.state = Timer(
                const Duration(seconds: 2),
                () => visibleController.state = false,
              );

              visibleController.state = true;
              countController.state++;
            },
            child: Text('$count')),
        portal: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: kThemeChangeDuration,
          builder: (context, progress, child) {
            return Material(
              elevation: 8 * progress,
              animationDuration: Duration.zero,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: Opacity(
                opacity: progress,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text('~~$count~~'),
          ),
        ));
  }
}

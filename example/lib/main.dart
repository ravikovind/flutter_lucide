import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lucide Icons Example',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Lucide Icons Example'),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  void _decrementCounter() => setState(() => _counter--);

  void _resetCounter() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times: '),
          Text('$_counter', style: Theme.of(context).textTheme.headlineLarge),
          // https://github.com/ravikovind/flutter_lucide/issues/8
          // LucideIcons.cloud_sync is showing as a balloon instead of the correct icon
          // Testing in UI to verify the fix for this issue cloud_sync vs balloon is resolved
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Icon(
                LucideIcons.cloud_sync,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                'cloud_sync icon',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'balloon icon',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Icon(
                LucideIcons.balloon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: _incrementCounter,
          child: const Icon(LucideIcons.plus),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: _resetCounter,
          child: const Icon(LucideIcons.refresh_ccw),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: _decrementCounter,
          child: const Icon(LucideIcons.minus),
        ),
      ],
    ),
  );
}

extension OfIconData on IconData {
  IconData copyWith({
    bool? matchTextDirection,
    List<String>? fontFamilyFallback,
  }) => IconData(
    codePoint,
    matchTextDirection: matchTextDirection ?? this.matchTextDirection,
    fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
  );
}

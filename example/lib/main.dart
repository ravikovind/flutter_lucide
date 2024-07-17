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
              const Text(
                'You have pushed the button this many times: ',
              ),
              if (_counter > 0) ...[
                const SizedBox(height: 16),
                IconButton.filled(
                    onPressed: _incrementCounter,
                    icon: const Icon(
                      LucideIcons.plus,
                      size: 32,
                    )),
              ] else if (_counter < 0) ...[
                const SizedBox(height: 16),
                IconButton.filled(
                  onPressed: _decrementCounter,
                  icon: const Icon(
                    LucideIcons.minus,
                    size: 32,
                  ),
                ),
              ],
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineLarge,
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

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
          /*
Testing Latest Changes -

feat(preview-comment): put x-ray at top if there are more than 7 changed icons to prevent them from being cut of by @jguddas in #3589
fix(icons): changed church icon by @karsa-mistmere in #2971
chore(metadata): Added tags to messages-square by @jamiemlaw in #3529
fix(icons): Optimise bug icons by @jamiemlaw in #3574
fix(icons): changed list/text & derived icons by @karsa-mistmere in #3568
fix(icons): changed panel-top-bottom-dashed icon by @jguddas in #3584
fix(icons): changed message-square-quote icon by @jguddas in #3550
fix(meta): added tag to ship metadata by @jguddas in #3559
fix(meta): add tags to id-card-lanyard metadata by @jguddas in #3534
fix(icons): changed calendar-cog icon by @jguddas in #3583
chore(deps): bump astro from 5.5.2 to 5.13.2 by @dependabot[bot] in #3564
feat(packages): add new package for flutter by @vqh2602 in #3536
feat(icons): added house-heart icon by @danielbayley in #3239
          */
          Icon(
            LucideIcons.messages_square,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            LucideIcons.bug,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),

          if (_counter > 0) ...[
            const SizedBox(height: 16),
            IconButton.filled(
              onPressed: _incrementCounter,
              icon: const Icon(LucideIcons.plus, size: 32),
            ),
          ] else if (_counter < 0) ...[
            const SizedBox(height: 16),
            IconButton.filled(
              onPressed: _decrementCounter,
              icon: const Icon(LucideIcons.minus, size: 32),
            ),
          ],
          Text('$_counter', style: Theme.of(context).textTheme.headlineLarge),
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

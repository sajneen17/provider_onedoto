import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'counter_provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Provider 1.0',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const CounterScreen(),
        );
      },
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  void _showProviderDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("About Provider"),
          content: const Text(
            "Provider is a state management solution in Flutter that allows you to "
                "share data across widgets, and respond to state changes. It's efficient, "
                "easy to use, and recommended by the Flutter team for simple state management.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Got it!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterProvider = context.watch<CounterProvider>();
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Provider',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeProvider.toggleTheme,
            tooltip: "Toggle Theme",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<DateTime>(
                stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData
                        ? '${snapshot.data!.toLocal()}'.split('.')[0]
                        : 'Loading date and time...',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Counter Value:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  '${counterProvider.count}',
                  key: ValueKey<int>(counterProvider.count),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: counterProvider.count < 0 ? Colors.red : Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      counterProvider.incrementCount();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Counter incremented!")),
                      );
                    },
                    backgroundColor: Colors.teal,
                    tooltip: 'Increment Counter',
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      counterProvider.decrementCount();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Counter decremented!")),
                      );
                    },
                    backgroundColor: Colors.teal,
                    tooltip: 'Decrement Counter',
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showProviderDescription(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'What is Provider?',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => counterProvider.resetCount(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

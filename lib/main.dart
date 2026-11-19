import 'package:material_ui/material_ui.dart';

import 'features/earnings/presentation/pages/earnings_page.dart';
import 'features/projects/presentation/pages/projects_page.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const FunngroApp());
}

class FunngroApp extends StatelessWidget {
  const FunngroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funngro Assessment',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funngro Assessment')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EarningsPage(userId: 'demo-user'),
                ),
              ),
              child: const Text('Part 1: Earnings (3,000 rows)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProjectsPage())),
              child: const Text('Part 2: Projects (pagination)'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_apod/di/main_component.dart';
import 'package:flutter_apod/screen/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final MainComponent appComponent = MainComponent();
  await appComponent.init();
  runApp(MyApp(appComponent));
}

class MyApp extends StatelessWidget {
  final MainComponent appComponent;

  const MyApp(this.appComponent, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Apod',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: HomePage(repository: appComponent.dataModule.postRepository),
      ),
    );
  }
}

// main_default.dart file launches the functionality by default.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_module/nutrition_ai_module.dart';

import 'app_secret.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stack) {
      // Handle the error gracefully
      log('Error: $error StackTrace: $stack');
    },
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PassioStatus? _passioStatus;

  final _passioConfig = PassioConfiguration(AppSecret.passioKey);

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _passioStatus == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Configuring SDK"),
                ],
              )
            : Text(_passioStatus?.mode.name ?? 'Something wrong'),
      ),
    );
  }

  void _initialize() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      NutritionAI.instance.configureSDK(_passioConfig).then((value) async {
        setState(() {
          _passioStatus = value;
        });
        if (value.mode == PassioMode.isReadyForDetection) {
          await NutritionAIModule.instance
              .setPassioKey(AppSecret.passioKey)
              .launch(context);
        }
      });
    });
  }
}

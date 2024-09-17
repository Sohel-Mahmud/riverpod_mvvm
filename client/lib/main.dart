import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soptify_mvvm_riverpod/core/service/navigation_service.dart';
import 'package:soptify_mvvm_riverpod/core/theme/theme.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/pages/signup_page.dart';
import 'package:soptify_mvvm_riverpod/features/auth/viewmodel/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // this container will allow us to access all the providers
  final container = ProviderContainer();
  // init shared prefs
  await container.read(authViewmodelProvider.notifier).initSharedPrefs();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: navigator.scaffoldMessengerKey,
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignUpPage(),
    );
  }
}


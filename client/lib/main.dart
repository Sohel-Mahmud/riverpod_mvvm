import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soptify_mvvm_riverpod/core/service/navigation_service.dart';
import 'package:soptify_mvvm_riverpod/core/theme/theme.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/pages/signup_page.dart';
import 'package:soptify_mvvm_riverpod/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:soptify_mvvm_riverpod/features/home/view/pages/home_page.dart';

import 'core/providers/current_user_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  // this container will allow us to access all the providers
  final container = ProviderContainer();
  // init shared prefs
  await container.read(authViewmodelProvider.notifier).initSharedPrefs();
  await container.read(authViewmodelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    
    return MaterialApp(
      scaffoldMessengerKey: navigator.scaffoldMessengerKey,
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignUpPage() : const HomePage(),
    );
  }
}


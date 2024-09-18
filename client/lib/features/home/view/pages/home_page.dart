import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soptify_mvvm_riverpod/core/providers/current_user_notifier.dart';

import '../../../auth/viewmodel/auth_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    print(user);
    return Scaffold(body: Center(child: Text("Home page")));
  }
}

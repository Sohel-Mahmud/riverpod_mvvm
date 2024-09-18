import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soptify_mvvm_riverpod/core/theme/app_pallete.dart';
import 'package:soptify_mvvm_riverpod/core/widgets/custom_fields.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:soptify_mvvm_riverpod/features/auth/viewmodel/auth_viewmodel.dart';

import '../../../../core/service/navigation_service.dart';
import '../../../home/view/pages/home_page.dart';

class SingInPage extends ConsumerStatefulWidget {
  const SingInPage({super.key});

  @override
  ConsumerState<SingInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SingInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // use provider.select to select specific variable
    // that you want to watch
    // dont watch the full viewmodelProvider
    // it will rebuild the whole widget
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));

    final ScaffoldMessengerState scaffoldMessenger =
        navigator.scaffoldMessengerKey.currentState!;

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          print("from signin page");
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text("Login Success")));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (_) => false,
          );
        },
        error: (error, stacktrace) {
          // postframe callback
          // to avoid snackbar not showing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scaffoldMessenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error.toString())));
          });
        },
        loading: () {
          /* ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text("Loading..."))); */
        },
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              CustomField(hintText: "Email", controller: emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: "Password",
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(
                  isLoading: isLoading,
                  buttonText: "Sign In",
                  onTap: () {
                    ref.read(authViewmodelProvider.notifier).loginUser(
                        email: emailController.text,
                        password: passwordController.text);
                  }),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                text: "Don't have an account? ",
                style: Theme.of(context).textTheme.titleMedium,
                children: const [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Pallete.gradient2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

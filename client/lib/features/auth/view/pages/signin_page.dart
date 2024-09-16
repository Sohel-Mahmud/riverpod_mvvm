import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:soptify_mvvm_riverpod/core/theme/app_pallete.dart';
import 'package:soptify_mvvm_riverpod/core/widgets/custom_fields.dart';
import 'package:soptify_mvvm_riverpod/features/auth/repositories/auth_remote_repository.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/widgets/auth_gradient_button.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SingInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Sign Up',
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
              AuthGradientButton(buttonText: "Sign In", onTap: () async {
                final res = await AuthRemoteRepository().login(
                  email: emailController.text,
                  password: passwordController.text,
                );

                final val = switch (res) {
                  Left(value: final l) => l,
                  Right(value: final r) => r
                };
                print(val);
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

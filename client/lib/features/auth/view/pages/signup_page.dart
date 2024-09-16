import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:soptify_mvvm_riverpod/core/theme/app_pallete.dart';
import 'package:soptify_mvvm_riverpod/core/widgets/custom_fields.dart';
import 'package:soptify_mvvm_riverpod/features/auth/repositories/auth_remote_repository.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
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
    nameController.dispose();
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
              CustomField(hintText: "Name", controller: nameController),
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
                  buttonText: "Sign Up",
                  onTap: () async {
                    final res = await AuthRemoteRepository().signup(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text.trim());

                    final val = switch (res) {
                      Left(value: final l) => l,
                      Right(value: final r) => r.toString(),
                    };
                    print(val);
                  }),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                text: "Already have an account? ",
                style: Theme.of(context).textTheme.titleMedium,
                children: const [
                  TextSpan(
                    text: "Sign In",
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

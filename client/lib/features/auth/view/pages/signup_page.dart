import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soptify_mvvm_riverpod/core/service/navigation_service.dart';
import 'package:soptify_mvvm_riverpod/core/theme/app_pallete.dart';
import 'package:soptify_mvvm_riverpod/core/widgets/custom_fields.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/pages/signin_page.dart';
import 'package:soptify_mvvm_riverpod/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:soptify_mvvm_riverpod/features/auth/viewmodel/auth_viewmodel.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch changes on usermodel
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));
    // listen can't return a widget
    // so in loading state we cant show a progressindicator
    // you can do this operation within authviewmodel
    // but you have to pass context to viewmodel
    // which is not recommended and you can't unit test your code
    // UI related stuff stays in view not in viewmodel
    final ScaffoldMessengerState scaffoldMessenger =
        navigator.scaffoldMessengerKey.currentState!;

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          print("from signup page");

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SingInPage();
          }));
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
        loading: () {},
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
                  isLoading: isLoading,
                  buttonText: "Sign Up",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      ref.read(authViewmodelProvider.notifier).signUpUser(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text);
                    }
                  }),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // navigate to sign in page
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SingInPage();
                  }));
                },
                child: RichText(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

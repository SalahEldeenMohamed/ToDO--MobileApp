import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/register/register_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home_screen.dart';

import '../../providers/auth_user_provider.dart';
import '../register/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.backgroundLightColor,
          child: Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome Back !!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 25),
                    ),
                  ),
                  CustomTextFormField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Email.';
                      }
                      final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(text);
                      if (!emailValid) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    label: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    controller: passwordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Password.';
                      }
                      if (text.length < 8) {
                        return 'Password Must Be Greater Than 8 characters';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        // button color
                        foregroundColor:
                            AppColors.whiteColor, // text/icon color
                      ),
                      onPressed: () {
                        Login();
                      },
                      child: Text('Login'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                    child: Text('Or Create New Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void Login() async {
    if (formKey.currentState?.validate() == true) {
      /// login
      DialogUtils.showLoading(context: context, message: 'Loading...');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthUserProvider>(
            context, listen: false);
        ;
        authProvider.updateUser(user);
        /// hide loading
        DialogUtils.hideLoading(context);
        /// show message
        DialogUtils.showMessage(
          context: context,
          message: 'Login Successfully',
          posActionName: 'Ok',
          posAction: () {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
        );
        print(credential.user?.uid ?? "");
      }
      // on FirebaseAuthException catch (e) {
      //   if (e.code == 'user-not-found') {
      //     /// hide loading
      //     DialogUtils.hideLoading(context);
      //     /// show message
      //     DialogUtils.showMessage(context: context, message: 'No user found for that email.', posActionName: 'Ok');
      //     print('No user found for that email.');
      //   } else if (e.code == 'wrong-password') {
      //     /// hide loading
      //     DialogUtils.hideLoading(context);
      //     /// show message
      //     DialogUtils.showMessage(context: context, message: 'Wrong password provided for that user.', posActionName: 'Ok');
      //     print('Wrong password provided for that user.');
      //   }
      // }
      catch (e) {
        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(
          context: context,
          message: e.toString(),
          posActionName: 'Ok',
        );
        print(e.toString());
      }
    }
  }
}

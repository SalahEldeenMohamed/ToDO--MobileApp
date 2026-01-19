import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/my_user.dart';

import '../../providers/auth_user_provider.dart';
import 'custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

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
            title: Text(
              'Create Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                  CustomTextFormField(
                    label: 'User Name',
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter User Name.';
                      }
                      return null;
                    },
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
                  CustomTextFormField(
                    label: 'Confirm Password',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    controller: confirmPasswordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Confirm Password.';
                      }
                      if (text != passwordController.text) {
                        return 'Confirm Password Does Not Match';
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
                        register();
                      },
                      child: Text('Create Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      /// register
      /// show loading
      DialogUtils.showLoading(context: context, message: 'loading');
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text
        );
        var authProvider = Provider.of<AuthUserProvider>(
            context, listen: false);
        ;
        authProvider.updateUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);
        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(
          context: context,
          message: 'Register Successfully',
          posActionName: 'Ok',
          posAction: () {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
        );
        print(credential.user?.uid ?? "");
      }
      // on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     /// hide loading
      //     DialogUtils.hideLoading(context);
      //     /// show message
      //     DialogUtils.showMessage(context: context, message: 'The password provided is too weak.');
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     /// hide loading
      //     DialogUtils.hideLoading(context);
      //     /// show message
      //     DialogUtils.showMessage(context: context, message: 'The account already exists for that email.');
      //     print('The account already exists for that email.');
      //   }
      // }
      catch (e) {
        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(context: context, message: e.toString());
        print(e.toString());
      }
    }
  }
}

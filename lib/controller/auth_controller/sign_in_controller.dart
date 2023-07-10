import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/routes.dart';
import '../../core/services/services.dart';

abstract class SignInController extends GetxController {
  goToSignUpPage();
  late TextEditingController email;
  late TextEditingController password;
  signIn(BuildContext context);
}

class SignInControllerImp extends SignInController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  MyServices myServices = Get.find();

  @override
  goToSignUpPage() {
    Get.toNamed(AppRoutes.signUp);
  }

  @override
  signIn(BuildContext context) async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      try {
        //showUpload(context: context);
      print(email.text);
      print(password.text);

        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        )
            .then((value) {

              print(1);
          myServices.sharedPreferences.setBool('isLogin', true);
        });
        Get.offAllNamed(AppRoutes.homePage);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'user-not-found',
            desc: 'No user found for that email.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Get.back();
            },
          ).show();
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'wrong-password',
            desc: 'Wrong password provided for that user.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Get.back();
            },
          ).show();
          print('Wrong password provided for that user.');
        }else{
          // AwesomeDialog(
          //   context: context,
          //   dialogType: DialogType.error,
          //   animType: AnimType.rightSlide,
          //   title: 'Opsss !',
          //   desc: 'An Some Error.' + e.message.toString(),
          //   btnCancelOnPress: () {},
          //   btnOkOnPress: () {
          //     Get.back();
          //   },
          // ).show();
        }
      }
    } else {
      print('please enter auth data');

    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    print('onInit');
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    print('dispose');

    super.dispose();
  }
}

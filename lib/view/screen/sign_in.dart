import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller/sign_in_controller.dart';
import '../../core/function/valid_input.dart';
import '../widget/auth_widget/custom_text_form_field_auth_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInControllerImp signInControllerImp = Get.put(SignInControllerImp());

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/img.png',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 60.0.h,
                        bottom: 50.0.h,
                        left: 20.0.w,
                        right: 20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Alzheimer\'s Assistant',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MarckScript'),
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                        Form(
                          key: signInControllerImp.formState,
                          child: Column(
                            children: [
                              GetBuilder<SignInControllerImp>(
                                  builder: (signInControllerImp) {
                                return CustomTextFormFieldAuthWidget(
                                  hintText: "Enter Your Email",
                                  labelText: "Email",
                                  textInputType: TextInputType.emailAddress,
                                  validator: (val) {
                                    return validInput(val!, 5, 100, 'email');
                                  },
                                  myEditingController:
                                      signInControllerImp.email,
                                );
                              }),
                              SizedBox(height: 20.0.h),
                              GetBuilder<SignInControllerImp>(
                                  builder: (signInControllerImp) {
                                return CustomTextFormFieldAuthWidget(
                                  hintText: "Enter Your Password",
                                  labelText: "Password",
                                  textInputType: TextInputType.visiblePassword,
                                  validator: (val) {
                                    return validInput(val!, 5, 40, 'password');
                                  },
                                  myEditingController:
                                      signInControllerImp.password,
                                );
                              }),
                              SizedBox(height: 10.0.h),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70.h,
                        ),
                        GetBuilder<SignInControllerImp>(
                            builder: (signInControllerImp) {
                          return InkWell(
                            onTap: () {
                              signInControllerImp.signIn(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xff08B5B6),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

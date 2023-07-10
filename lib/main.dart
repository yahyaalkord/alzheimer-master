import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/core/constant/routes.dart';
import 'package:patient_app/view/screen/home_page.dart';
import 'package:patient_app/view/screen/patient_info.dart';
import 'package:patient_app/view/screen/sign_in.dart';
import 'package:patient_app/view/screen/task_page.dart';

import 'core/middleware/my_middle_ware.dart';
import 'core/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: AppRoutes.signIn,
            page: () => SignIn(),
            middlewares: [MyMiddleWare()
            ]),
        GetPage(name: AppRoutes.homePage, page: () => HomePage()),
        GetPage(name: AppRoutes.patientInfo, page: () => const PatientInfo()),
        GetPage(name: AppRoutes.taskPage, page: () => const TaskPage()),
      ],
      initialRoute: AppRoutes.signIn,
    );
  }
}

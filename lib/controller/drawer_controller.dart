import 'package:patient_app/core/constant/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../core/services/services.dart';

abstract class DrawerController extends GetxController {
  // goToNotifications();
  goToHomePage();
  // goToRegisterPatientPage();
  Future<QuerySnapshot> getPatientNameAndEmail();
  signOut();
}

class DrawerControllerImp extends DrawerController {
  String? patientId;
  MyServices myServices = Get.find();

  @override
  goToHomePage() {
    Get.toNamed(AppRoutes.homePage);
  }

  @override
  Future<QuerySnapshot> getPatientNameAndEmail() async {
    patientId = FirebaseAuth.instance.currentUser!.uid;
    print('patientId : $patientId');
    return await myServices.collectionReferencePatient
        .where('isAdmin', isEqualTo: false)
        .where('patientId', isEqualTo: patientId)
        .get();
  }

  @override
  signOut() {
    FirebaseAuth.instance.signOut();
    myServices.sharedPreferences.setBool('isLogin', false);
    Get.offAllNamed(AppRoutes.signIn);
  }

  @override
  goToRegisterPatientPage() {
    Get.offAllNamed(AppRoutes.signUpFotPatent);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  late CollectionReference collectionReferenceCaregiver;
  String? patientId;
  String? caregiverId;
  late CollectionReference collectionReferencePatient;
  late CollectionReference collectionReferenceLocation;
  late CollectionReference collectionReferenceTask;
  late FirebaseMessaging messaging;
  Future<MyServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    collectionReferenceCaregiver =
        await FirebaseFirestore.instance.collection("caregiver");
    collectionReferencePatient =
        await FirebaseFirestore.instance.collection('patient');
    collectionReferenceLocation =
        FirebaseFirestore.instance.collection('location');
    collectionReferenceTask = FirebaseFirestore.instance.collection('task');
    messaging = FirebaseMessaging.instance;

    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}

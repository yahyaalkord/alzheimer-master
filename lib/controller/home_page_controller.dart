import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

import '../core/constant/routes.dart';
import '../core/services/services.dart';

abstract class HomePageController extends GetxController {
  Future getPosition();
  void getUserInfo();
  stopAudio();
  playAudio();
  sendNotification(
      {required String title, required String body, required String id});
}

class HomePageControllerImp extends HomePageController {
  Position? currentPosition;
  String? token;
  String? caregiverId;
  MyServices myServices = Get.find();
  List<double> accelerometerValues = [0, 0, 0, 0];
  List<String> letters = ["x", "y", "z", "svm"];
  double? svm;
  bool isDeduction = false;
  bool isFallen = false;
  final player = AudioPlayer();
  String name = "patient";
  String phone = '';

  final String serverToken =
      'AAAAdFkfDgg:APA91bHvTCTNh3q5SS6J-Vgq3MnjNiXrlLwVeRRT4v715ihiNibczNDIqGom3pqu8IIm6boSvqM7bllG2sgItU9dpgfjACEYmms5AY4lbqHBxozbn_W4qrd18BvNZ8upIRrQbCa5vdPX';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  sendNotification(
      {required String title, required String body, required String id}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString()
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id,
            'status': 'done'
          },
          'to':
              "dGPwN72OQ-yd54TTnv6NDq:APA91bF_6vVlMnj-lT3aM7DA_FqWe4_IVKLfN4Nswb7MVJjY8e25n151QJWPeoeXh4oG2AzqVvhmVvdL2F7HviAHImotIUHZRA71to0C_7-yw3RMyE0MVKu4c3Otudjab6-B8jUHu85E"
        },
      ),
    );
    print(body);
  }



  Future<bool> sendNotificationCaregiver(
      String tokens, String body, String title,
      {String subTitle = ""}) async {

    final msg = {
      'body': body,
      'title': title,
      'subtitle': subTitle,
      'sound': 'default',
    };
    final fields = {
      'registration_ids': tokens,
      'notification': msg,
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'android': {
        'priority': 'high',
        'notification': {
          'sound': 'default',
        },
      },
      'apns': {
        'payload': {
          'sound': 'default',
        },
      },
    };
    final headers = {
      'Authorization': 'key=$serverToken',
      'Content-Type': 'application/json',
      'apns-topic': 'io.flutter.plugins.firebase.messaging',
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: jsonEncode(fields),
    );

    return response.statusCode == 200;
  }



  // @override
  // Future<QuerySnapshot> getCaregiver() async {
  //   caregiverId = FirebaseAuth.instance.currentUser!.uid;
  //   print('caregiverId : $caregiverId');
  //
  //   return await myServices.collectionReferenceCaregiver
  //       .where('isAdmin', isEqualTo: true)
  //       .get();
  // }
  // @override
  // Future<QuerySnapshot> getCaregiver() async {
  //   String patientId = FirebaseAuth.instance.currentUser!.uid;
  //   print('patientId: $patientId');
  //
  //   QuerySnapshot patientSnapshot = await myServices.collectionReferencePatient
  //       .where('patientId', isEqualTo: patientId)
  //       .get();
  //
  //   if (patientSnapshot.docs.isNotEmpty) {
  //     String caregiverId = patientSnapshot.docs[0].get('caregiverId');
  //     print('caregiverId: $caregiverId');
  //
  //     return myServices.collectionReferenceCaregiver
  //         .where("caregiverId", isEqualTo: caregiverId)
  //         .get();
  //   } else {
  //     // Handle the case when no patient document is found
  //     return Future.error('No patient document found');
  //   }
  // }
  Future<String> getCaregiver() async {
    String patientId = FirebaseAuth.instance.currentUser!.uid;
    print('patientId: $patientId');

    QuerySnapshot patientSnapshot = await myServices.collectionReferencePatient
        .where('patientId', isEqualTo: patientId)
        .get();

    if (patientSnapshot.docs.isNotEmpty) {
      String caregiverId = patientSnapshot.docs[0].get('caregiverId');
      print('caregiverId: $caregiverId');

      QuerySnapshot caregiverSnapshot = await myServices
          .collectionReferenceCaregiver
          .where("caregiverId", isEqualTo: caregiverId)
          .get();

      if (caregiverSnapshot.docs.isNotEmpty) {
        phone = caregiverSnapshot.docs[0].get('phone');
        print('phone: $phone');
        return phone;
      } else {
        // Handle the case when no caregiver document is found
        throw Exception('No caregiver document found');
      }
    } else {
      // Handle the case when no patient document is found
      throw Exception('No patient document found');
    }
  }

  @override
  void getUserInfo() async {
    await myServices.collectionReferencePatient
        .where("patientId", isEqualTo: myServices.patientId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.docs[0].data() as Map<String, dynamic>;
      name = data['name'];
    });
  }

  void getCaregiverInfo() async {
    getCaregiver();
    QuerySnapshot caregiverSnapshot = await myServices
        .collectionReferenceCaregiver
        .where("caregiverId", isEqualTo: caregiverId)
        .get();
    if (caregiverSnapshot.docs.isNotEmpty) {
      phone = caregiverSnapshot.docs[0].get('phone');
    }
  }

  goToShowTaskPage() {
    Get.toNamed(AppRoutes.taskPage);
  }

  @override
  Future getPosition() async {
    bool services = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission;
    print('========================= $services  ============================');
    if (services == false) {
      print('lllllllllllllllllllllll');
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.error,
      //   animType: AnimType.rightSlide,
      //   title: 'services',
      //   desc: 'services Not Enabled',
      //   btnCancelOnPress: () {
      //
      //   },
      //   btnOkOnPress: () {
      //     Get.back();
      //   },
      // ).show();
    }
    locationPermission = await Geolocator.checkPermission();
    print('================= ${locationPermission}');
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      print('mmmmmmmmmmmmmmmmmmmmmmmmmm');
    }
    if (locationPermission == LocationPermission.always) {
      currentPosition = await Geolocator.getCurrentPosition();
      print('nnnnnnnnnnnnnnnnnnnnnnnnnnn');
      myServices.collectionReferenceLocation.doc(myServices.patientId).update({
        'lat': currentPosition!.latitude,
        'lng': currentPosition!.longitude,
      }).then((value) {
        print('sucsses');
      }).catchError((e) {
        print('fail');
      });
    }
    if (locationPermission == LocationPermission.whileInUse) {
      String patientId = FirebaseAuth.instance.currentUser?.uid ?? '';
      print(patientId);
      print('while In Use');
      currentPosition = await Geolocator.getCurrentPosition();
      print(currentPosition!.latitude);
      print(currentPosition!.longitude);
      myServices.collectionReferenceLocation.doc(patientId).update({
        'lat': currentPosition!.latitude,
        'lng': currentPosition!.longitude,
      }).then((value) {
        print('sucsses');
      }).catchError((e) {
        print('fail');
      });
    }
  }

  @override
  playAudio() {
    player.setAsset("assets/audio/alert.mp3");
    player.play();
    

  }

  

  stopAudio() {
    player.setAsset("assets/audio/alert.mp3");
    player.stop();
  }

  @override
  void onInit() async {
    await getPosition();
    myServices.patientId = FirebaseAuth.instance.currentUser!.uid;
    // getUserInfo();

    getUserInfo();
    getCaregiver();
    getCaregiverInfo();
    super.onInit();
  }
}

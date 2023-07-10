import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/view/screen/diary_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/patient_info_controller.dart';
import '../../model/common/navigation_drawer.dart' as custom;

import '../../controller/home_page_controller.dart';
import '../widget/custom_home_container.dart';
import '../widget/custom_row_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    HomePageControllerImp homePageControllerImp =
        Get.put(HomePageControllerImp());

    PatientInfoControllerImp patientInfoControllerImp =
        Get.put(PatientInfoControllerImp());


  bool isFallen = false;
  bool isOpenDilog = false;
  String? userId;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

    _streamSubscriptions.add(
      accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            if(event.y < -10.0){
              isFallen = true;
            }
          });
      }),
    );
  }
  //location services  - enabled=>true  - disabled=>false
  @override
  Widget build(BuildContext context) {
    
    if(isFallen && !isOpenDilog){
      isOpenDilog = true;
      Future.delayed(const Duration(seconds: 1),(){
        homePageControllerImp.playAudio();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Are you sure ?',
            desc: 'Are you sure to send a notice to the caregiver?',
            btnCancelOnPress: () {

              homePageControllerImp.sendNotification(
                title: "Fall detection:", body: "&& Name && has fallen!", id: "id");


            },
            btnOkOnPress: () {
              isFallen = false;
              isOpenDilog = false;
              homePageControllerImp.stopAudio();
              Get.back();
            },
          ).show();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Alzheimer\'s Assistant"),
        backgroundColor: const Color(0xff096b6c),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            if(userId!=null){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DiaryScreen(id: userId!);
              },));
            }
          },icon: const Icon(Icons.note_alt_outlined,color: Colors.white,size: 32,))
        ],
      ),
      drawer: const custom.NavigationDrawer(),
      
      body: Center(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomHomeContainer(
                      widget: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                                future:
                                    patientInfoControllerImp.getPatientInfo(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    userId = snapshot.data.docs[0].data()['patientId'];
                                    return Column(
                                      children: [
                                        CustomRowWidget(
                                          title:
                                              "${snapshot.data.docs[0].data()['name']}",
                                          icon: Icons.person,
                                          fontSize: 24,
                                          iconSize: 24,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        CustomRowWidget(
                                          title:
                                              "${snapshot.data.docs[0].data()['email']}",
                                          icon: Icons.email,
                                          fontSize: 20,
                                          iconSize: 24,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        CustomRowWidget(
                                          title:
                                              "${snapshot.data.docs[0].data()['phone']}",
                                          icon: Icons.phone,
                                          fontSize: 20,
                                          iconSize: 24,
                                        ),
                                      ],
                                    );
                                  } else if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return const Text("no patient available");
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                // Container(
                //   margin: EdgeInsets.all(24),
                //   padding: EdgeInsets.all(24),
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(24),
                //     color: Color(0xff096b6c),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.directions_run_sharp,
                //         color: Colors.white,
                //         size: 44,
                //       ),
                //       Column(
                //         children: [
                //           Text(
                //             'Your Acceleration State:',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           //Text('${homePageControllerImp.currentPosition!.longitude}'),
                //           GetBuilder<HomePageControllerImp>(
                //               builder: (homePageControllerImp) {
                //             return Text(
                //               '${homePageControllerImp.accelerometerValues[3]}',
                //               style: TextStyle(color: Colors.white),
                //             );
                //           }),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.all(24),
                //   padding: EdgeInsets.symmetric(horizontal: 16),
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(24),
                //     color: Color(0xff409d9d),
                //   ),
                //   child: GestureDetector(
                //     onTap: () {
                //       homePageControllerImp.goToShowTaskPage();
                //     }, // Image tapped
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           'assets/images/reminder.png',
                //           fit: BoxFit.cover, // Fixes border issues
                //           width: 110.0,
                //           height: 110.0,
                //         ),
                //         Text(
                //           'Check Your Tasks',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    height: 600,
                    margin: const EdgeInsets.all(20),
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25,
                      ),
                      children: [
                        GestureDetector(
                          onTap: () {
                            homePageControllerImp.goToShowTaskPage();
                          },
                          child: Image.asset(
                            'assets/images/reminder1.png',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/chat.png',
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            homePageControllerImp.getCaregiver();
                            homePageControllerImp.getCaregiverInfo();

                            if (homePageControllerImp.phone != null) {
                              String caregiverPhoneNumber =
                                  homePageControllerImp.phone;
                              print(caregiverPhoneNumber);
                              launchUrl(Uri.parse(
                                  'tel:${homePageControllerImp.phone}'));
                            }
                          },
                          child: Image.asset(
                            'assets/images/call.png',
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await homePageControllerImp.getCaregiver();
                            homePageControllerImp.getCaregiverInfo();

                            if (homePageControllerImp.phone != null) {
                              String caregiverPhoneNumber =
                                  homePageControllerImp.phone;
                              print(caregiverPhoneNumber);
                              launchUrl(Uri.parse(
                                  'sms:${homePageControllerImp.phone}'));
                            }
                          },
                          child: Image.asset(
                            'assets/images/sms.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
      ),
    );
  }

  void _showDialog(context) {
    

    //  showDialog(context: ctx, builder: (ctx){
    //   return SizedBox(
    //     height: MediaQuery.sizeOf(ctx).height / 3,
    //     width: MediaQuery.sizeOf(ctx).width,
    //     child: Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       child: Column(
    //         children: [
    //           Text('Note !',style: TextStyle(
    //             fontSize: 15,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.black
    //           ),),
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }
}

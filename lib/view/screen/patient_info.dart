import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/patient_info_controller.dart';
import '../widget/custom_row_widget.dart';
import '../widget/custom_select_widget.dart';
import '../widget/other/custom_home_container.dart';

class PatientInfo extends StatelessWidget {
  const PatientInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PatientInfoControllerImp patientInfoControllerImp =
        Get.put(PatientInfoControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Information"),
        backgroundColor: Color(0xff096b6c),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHomeContainer(
              widget: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 50,
                    // ),
                    FutureBuilder(
                        future: patientInfoControllerImp.getPatientInfo(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
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
                                  height: 10,
                                ),
                                CustomRowWidget(
                                  title:
                                      "${snapshot.data.docs[0].data()['email']}",
                                  icon: Icons.email,
                                  fontSize: 20,
                                  iconSize: 24,
                                ),
                                const SizedBox(
                                  height: 10,
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
                            return const Text("no user available");
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Monitoring",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Container(
              height: 600,
              margin: const EdgeInsets.all(20),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                ),
                children: [
                  CustomSelectWidget(
                    color: Colors.blue.shade400,
                    title: "Reminder",
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      patientInfoControllerImp.goToShowTaskPage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_page_controller.dart';



class CustomPatientWidget extends StatelessWidget {

  //late String userEmail;
  late String userName;
  late String name;
  late String userId;

  CustomPatientWidget({
    required this.userName,
    //required this.userEmail,
    required this.userId,
    required this.name
  });

  @override
  Widget build(BuildContext context) {

   HomePageControllerImp homePageControllerImp =
       Get.put(HomePageControllerImp());
    return MaterialButton(
      onPressed: (){
       // homePageControllerImp.goToUserDetails(userId: userId);
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(top:20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, blurRadius: 2, offset: Offset(1, 3)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(

             radius: 45,

              child: Text(name,
                style: const TextStyle(
                    fontSize: 30
                ),),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}

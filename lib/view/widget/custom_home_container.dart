import 'package:flutter/material.dart';

class CustomHomeContainer extends StatelessWidget {
  final Widget widget;
  const CustomHomeContainer({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
          gradient: LinearGradient(
            colors: [
              // Colors.purple.shade100,
              // Colors.purple.shade200,
              // Colors.purple.shade300,
              // Colors.purple.shade400,
              // Colors.purple.shade500,
              // Colors.purple.shade600,
              // Colors.white,

              Color(0xffc3f3f3),
              Color(0xff75cece),

              Color(0xff409d9d),

              Color(0xff096b6c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )),
      child: widget,
    );
  }
}

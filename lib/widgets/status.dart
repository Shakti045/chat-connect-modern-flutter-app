import 'package:chatconnect/screens/contactstatus.dart';
import 'package:chatconnect/widgets/mystatus.dart';
import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.all(10),
      child:SingleChildScrollView(
        child: Column(
          children: [
            MyStatus(),
           SizedBox(height: 30,),
           OtherUserStatus(),
           
          ],
        ),
      ) ,
      );
  }
}

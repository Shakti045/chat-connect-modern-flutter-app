import 'package:flutter/material.dart';

class MediaOptionsButton extends StatelessWidget {
  const MediaOptionsButton(
      {super.key,
      required this.icon,
      required this.labeltext,
      required this.onclick,
      required this.buttonbgc
      });
  final Icon icon;
  final String labeltext;
  final void Function() onclick;
  final Color buttonbgc;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onclick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: buttonbgc
            ) ,
            padding: const EdgeInsets.all(10),
            child: Center(
              child:icon ,
            ),
          ),
          const SizedBox(height: 5,),
          Text(labeltext,style: const TextStyle(color: Colors.white54),),
        ],
      ),
    );
  }
}

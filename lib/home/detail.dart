import 'package:flutter/material.dart';
import 'package:society_parking/controller/user_controller/user_controller.dart';

class Detail extends StatelessWidget {
     const Detail(
      {Key? key,
      required this.detail,
      this.iscall = false,
      this.iscar = false,
      this.isbike = false,
      this.isperson = false,
      this.ishome = false}) : super(key: key);

  final String detail;
  final bool iscall;
  final bool iscar;
  final bool isbike;
  final bool isperson;
  final bool ishome;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (ishome)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        if (iscar)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        if (isbike)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.two_wheeler_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        if (isperson)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        const Text(
          "     :    ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        /*Container(
          child: Expanded(child: Text(detail)),
        ),*/
        Expanded(child: Text(detail)),

        if (iscall)
          IconButton(
              icon: const Icon(
                Icons.call,
                color: Colors.cyan,
              ),
              onPressed: () {
                UserController().callDial(phoneNumber: detail);
              }),
      ],
    );
  }
}

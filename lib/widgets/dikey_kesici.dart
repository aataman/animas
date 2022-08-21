import 'package:flutter/material.dart';

class DikeyKesici extends StatelessWidget {
  const DikeyKesici({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: Container(
            width: 7.5,
            height: 7.5,
            // color: Colors.black,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: Container(
            width: 7.5,
            height: 7.5,
            // color: Colors.black,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

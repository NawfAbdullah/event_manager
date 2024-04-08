import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 30,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/shakir.jpeg',
                    width: 25,
                    height: 25,
                  ),
                ),
              )),
          Positioned(
              left: 20,
              child: Container(
                padding: EdgeInsets.all(2),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/zameel.jpg',
                    width: 25,
                    height: 25,
                  ),
                ),
              )),
          Positioned(
              left: 40,
              child: Container(
                padding: EdgeInsets.all(2),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/faaiz.jpeg',
                    width: 25,
                    height: 25,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

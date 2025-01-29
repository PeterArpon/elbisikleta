import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const Center(
        child: Text('Welcome to Elbisikleta!'),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Elbisikleta',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {

        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFE7E8E8),
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Color(0xFFE7E8E8),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: SvgPicture.asset('assets/icons/dots.svg',
              height: 5,
              width: 5,
            ),
          ),
        ),
      ],
    );
  }
}
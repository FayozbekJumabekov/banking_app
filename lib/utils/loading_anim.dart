import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnim extends StatelessWidget {
  const LoadingAnim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child:Center(
          child: Lottie.asset('assets/anims/loading.json', width: 100))
    );
  }
}

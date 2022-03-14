import 'package:flutter/material.dart';

class TextFieldDecoration extends StatelessWidget {
  Widget child;
   TextFieldDecoration({required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(171, 171, 171, 0.7),
                blurRadius: 20,
                offset: Offset(0, 10)),
          ]),
      child: child,
    );
  }
}

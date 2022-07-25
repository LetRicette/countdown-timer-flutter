import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  const RoundButton({required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.purple[900],
        child: Icon(
          icon,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}

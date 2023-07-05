import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget Logo() {
  return AvatarGlow(
    endRadius: 90,
    duration: const Duration(seconds: 2),
    glowColor: Colors.white24,
    repeat: true,
    repeatPauseDuration: const Duration(seconds: 2),
    startDelay: const Duration(seconds: 1),
    child: Material(
        elevation: 8.0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: Lottie.asset(
            'img/logo.json',
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
          radius: 50.0,
        )),
  );
}

Widget loding() {
  return Scaffold(
    body: Center(child: Logo()),
  );
}

import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/screens/RegisterScreen.dart';
import 'package:admindukanv1/screens/loginScreen.dart';
import 'package:admindukanv1/widget/logo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:admindukanv1/widget/buttom_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int dur = 700;
  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: login_bg,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeInDown(
                    duration: Duration(milliseconds: dur), child: Logo()),
                FadeInDown(
                  duration: Duration(milliseconds: dur),
                  child: const Text(
                    "مرحبا",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: color),
                  ),
                ),
                FadeInDown(
                  duration: Duration(milliseconds: dur * 2),
                  child: const Text(
                    "في تسعيرة",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: color),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                FadeInDown(
                  duration: Duration(milliseconds: dur * 2),
                  child: const Text(
                    "يمكنك عرض الاسعار",
                    style: TextStyle(fontSize: 20.0, color: color),
                  ),
                ),
                FadeInDown(
                  duration: Duration(milliseconds: dur * 2),
                  child: const Text(
                    " ومتابعتها من هنا",
                    style: TextStyle(fontSize: 20.0, color: color),
                  ),
                ),
                const SizedBox(
                  height: 100.0,
                ),
                ElasticIn(
                  duration: const Duration(milliseconds: 1000 * 4),
                  child: animatedButtonUI('تسجيل دخول', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                ElasticIn(
                  duration: const Duration(milliseconds: 1000 * 4),
                  child: textButton('ليس لدي حساب ', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  }),
                ),
              ],
            ),
          )),
    );
  }
}

/*
 TweenAnimationBuilder(
                    tween: findAnimation('button_scale', 0.0, animationlist),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: double.parse(value.toString()),
                        child: animatedButtonUI('تسجيل دخول', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }),
                      );
                    })
 */
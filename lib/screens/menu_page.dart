import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/screens/PutProfileScreen.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:admindukanv1/screens/home.dart';
import 'package:admindukanv1/screens/ptofile.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemBody(
                    'الرئيسية',
                    1,
                    const Icon(
                      Icons.home_filled,
                      size: 30,
                    ), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Home()),
                      (route) => false);
                  // Navigator.pop(context);
                }),
                itemBody(
                    'البروفايل',
                    2,
                    const Icon(
                      Icons.person,
                      size: 30,
                    ), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Profile()),
                      (route) => false);
                }),
                itemBody(
                    'تسجيل خروج',
                    4,
                    const Icon(
                      Icons.logout,
                      size: 30,
                    ), () async {
                  bool logout = await removToken();
                  if (logout) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                        (route) => false);
                  }
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget itemBody(String text, int index, Icon icon, ontop) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 45, right: 10),
        child: InkWell(
          onTap: ontop,
          child: ElasticIn(
            duration: Duration(milliseconds: 400 * index),
            child: Row(
              children: [
                icon,
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ));
  }
}

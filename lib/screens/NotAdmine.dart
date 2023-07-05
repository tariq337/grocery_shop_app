import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:flutter/material.dart';

class NotAdmine extends StatefulWidget {
  const NotAdmine({Key? key}) : super(key: key);

  @override
  State<NotAdmine> createState() => _NotAdmineState();
}

class _NotAdmineState extends State<NotAdmine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                  'لم يتم تخويلك من قبل المسؤلين بعد الرجاء التواصل معنا لمذيد من المعلومات',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ),
            GestureDetector(
              onTap: () async {
                bool logout = await removToken();
                if (logout) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .7,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: login_bg),
                child: const Center(
                  child: Text(
                    'تسجبل خروج',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

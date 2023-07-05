import 'package:flutter/material.dart';

const Color login_bg = Color(0xFF00C470);
const Color signup_bg = Color(0xFF000A54);
const int delayedAmount = 400;

const double defpaultPadding = 16.0;
const Duration defaultDuration = Duration(milliseconds: 300);

const String startUrl = '';

const String loginUrl = startUrl + '/users/login';
const String registerUrl = startUrl + '/users/register';
const String logoutUrl = startUrl + '/users/logout';
const String userProfile = startUrl + '/users/me';
const String getdataUrl = startUrl + '/products/me/details';
const String passdataUrl = startUrl + '/products';

const serverError = 'خطاء في الاتصال بالسبرفر';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mess(
    BuildContext context, String msg, Color color) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: Row(
      children: [
        Icon(color == Colors.red ? Icons.error : Icons.done,
            color: Colors.white),
        Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  ));
}

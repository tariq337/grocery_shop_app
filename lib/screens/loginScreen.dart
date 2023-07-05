import 'dart:developer';
import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/controllers/loginControllers.dart';
import 'package:admindukanv1/screens/RegisterScreen.dart';
import 'package:admindukanv1/screens/home.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:admindukanv1/widget/buttom_login.dart';
import 'package:admindukanv1/widget/logo.dart';
import 'package:admindukanv1/widget/text_form.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final nodephone = FocusNode();
  final nodepassword = FocusNode();

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  Size get size => MediaQuery.of(context).size;
  int dur = 700;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            height: size.height,
            decoration: const BoxDecoration(
              color: login_bg,
            ),
            child: Center(
              child: Obx(() {
                return LoadingOverlay(
                  color: Colors.black54,
                  opacity: .5,
                  isLoading: authController.isLoading.value,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInDown(
                              duration: Duration(milliseconds: dur),
                              child: Logo()),
                          FadeInDown(
                            duration: Duration(milliseconds: dur),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .01,
                                  bottom: size.height * .05),
                              child: const Text(
                                'تسجيل دخول',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ElasticIn(
                                duration: Duration(milliseconds: dur),
                                child: textEdit(
                                    (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'ادخل رقم الهاتف';
                                      }
                                      return null;
                                    },
                                    phone,
                                    TextInputType.phone,
                                    'رقم الهاتف',
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    nodephone,
                                    (value) {
                                      FocusScope.of(context)
                                          .requestFocus(nodepassword);
                                    })),
                          ),
                          SizedBox(
                            height: size.height * .05,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ElasticIn(
                                duration: Duration(milliseconds: dur),
                                child: textEdit(
                                    (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'ادخل كلمة المرور';
                                      }
                                      if (value.length < 8) {
                                        return 'بجب ان تكون كلمة المرور اكبر من 8';
                                      }
                                      return null;
                                    },
                                    password,
                                    TextInputType.visiblePassword,
                                    'كلمة المرور',
                                    const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    nodepassword,
                                    (value) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    })),
                          ),
                          SizedBox(
                            height: size.height * .05,
                          ),
                          ElasticIn(
                              duration: Duration(milliseconds: dur * 2),
                              child: animatedButtonUI('تسجيل دخول', () async {
                                if (_formKey.currentState!.validate()) {
                                  await authController.LoginController(
                                      phone.text, password.text);

                                  if (authController.apiKey.value.isNotEmpty) {
                                    String isSetToken = await setToken(
                                        authController.apiKey.value);
                                    if (isSetToken.isNotEmpty) {
                                      log(isSetToken);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                      );
                                    } else {
                                      mess(context, 'خطاء غير متوقع',
                                          Colors.red);
                                    }
                                  } else {
                                    mess(context, authController.error.value,
                                        Colors.red);
                                  }
                                }
                              })),
                          SizedBox(
                            height: size.height * .06,
                          ),
                          ElasticIn(
                            duration: Duration(milliseconds: dur * 2),
                            child: textButton('ليس لدي حساب', () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegisterScreen()),
                                  (Route<dynamic> route) => false);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ));
  }
}

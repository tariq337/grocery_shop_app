import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/controllers/loginControllers.dart';
import 'package:admindukanv1/screens/home.dart';
import 'package:admindukanv1/screens/loginScreen.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:admindukanv1/widget/buttom_login.dart';
import 'package:admindukanv1/widget/logo.dart';
import 'package:admindukanv1/widget/text_form.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController groceryName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  Size get size => MediaQuery.of(context).size;

  Location location = Location();
  late bool isServicesEnibl = false;
  late PermissionStatus _permissionStatus;
  late LocationData locationData;
  late bool isgetlocation = false;
  final nodephone = FocusNode();
  final nodepassword = FocusNode();
  final nodeUserName = FocusNode();
  final nodeGroceryName = FocusNode();

  @override
  void initState() {
    getLocationdata();
    super.initState();
  }

  int dur = 700;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: login_bg,
          ),
          child: Center(
            child: Obx(() {
              return LoadingOverlay(
                color: Colors.black54,
                opacity: .3,
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
                                bottom: size.height * .03),
                            child: const Text(
                              "تسجيل حساب جديد",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // FadeInDown(
                        //   duration: Duration(milliseconds: dur),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         top: size.height * .01,
                        //         bottom: size.height * .03),
                        //     child: const Text(
                        //       "علي الواتس 0929279652",
                        //       style: TextStyle(
                        //         fontSize: 28,
                        //         color: Colors.white,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ElasticIn(
                              duration: Duration(milliseconds: dur),
                              child: textEdit(
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'ادخل اسم المستخدم';
                                    }
                                    return null;
                                  },
                                  username,
                                  TextInputType.text,
                                  'اسم المستخدم',
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  nodeUserName,
                                  (value) {
                                    FocusScope.of(context)
                                        .requestFocus(nodeGroceryName);
                                  })),
                        ),
                        SizedBox(
                          height: size.height * .02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ElasticIn(
                              duration: Duration(milliseconds: dur),
                              child: textEdit(
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'ادخل اسم المحل';
                                    }
                                    return null;
                                  },
                                  groceryName,
                                  TextInputType.text,
                                  'اسم المحل',
                                  const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  nodeGroceryName,
                                  (value) {
                                    FocusScope.of(context)
                                        .requestFocus(nodephone);
                                  })),
                        ),
                        SizedBox(
                          height: size.height * .02,
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
                                  TextInputType.number,
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
                          height: size.height * .02,
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
                          height: size.height * .02,
                        ),
                        ElasticIn(
                            duration: Duration(milliseconds: dur * 2),
                            child: animatedButtonUI('تسجبل دخول', () async {
                              if (_formKey.currentState!.validate()) {
                                if (isgetlocation) {
                                  await authController.regesterController(
                                      username.text,
                                      groceryName.text,
                                      phone.text,
                                      password.text,
                                      '${locationData.latitude},${locationData.longitude}');
                                  if (authController.apiKey.value.isNotEmpty) {
                                    String isSetToken = await setToken(
                                        authController.apiKey.value);
                                    if (isSetToken.isNotEmpty) {
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
                                    username.text = '';
                                    groceryName.text = '';
                                    password.text = '';
                                    phone.text = '';
                                    mess(context, authController.error.value,
                                        Colors.red);
                                  }
                                } else {
                                  mess(context, 'لم يتم تحديد الموقع',
                                      Colors.red);
                                  getLocationdata();
                                }
                              }
                            })),
                        SizedBox(
                          height: size.height * .02,
                        ),
                        ElasticIn(
                          duration: Duration(milliseconds: dur * 2),
                          child: animatedButtonUI('لدي حساب', () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginScreen()),
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
      ),
    );
  }

  void getLocationdata() async {
    isServicesEnibl = await location.serviceEnabled();
    if (!isServicesEnibl) {
      isServicesEnibl = await location.requestService();
      if (isServicesEnibl) return;
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();
    setState(() {
      isgetlocation = true;
    });
  }
}


/**
 * 
 * GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloding = true;
                                });
                                Auth auth = Auth();

                                if (isgetlocation) {
                                  auth = await register(
                                      username.text,
                                      groceryName.text,
                                      phone.text,
                                      password.text,
                                      '${locationData.latitude},${locationData.longitude}');
                                  if (auth.error.isEmpty) {
                                    setState(() {
                                      isloding = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                                apiKey: auth.apiKey,
                                              )),
                                    );
                                  } else {
                                    setState(() {
                                      isloding = false;
                                    });
                                    username.text = '';
                                    groceryName.text = '';
                                    password.text = '';
                                    phone.text = '';
                                    mess(context, auth.error, Colors.red);
                                  }
                                } else {
                                  setState(() {
                                    isloding = false;
                                  });
                                  mess(context, 'لم يتم تحديد الموقع',
                                      Colors.red);
                                  getLocationdata();
                                }
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                color: Colors.white,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 55, vertical: 15),
                                child: Text(
                                  'تسجيل دخول',
                                  style: TextStyle(
                                      color: login_bg,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                      
 * 
 */
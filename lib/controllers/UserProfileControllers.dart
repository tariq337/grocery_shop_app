import 'dart:io';
import 'package:admindukanv1/screens/NotAdmine.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:dio/src/form_data.dart' as formdara;
import 'package:dio/src/multipart_file.dart' as multipart;
import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/models/UserProfileModels.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'dart:developer';

class UserController extends GetxController {
  RxBool isLoading = false.obs;

  RxString error = ''.obs;
  Rx<UserProfileModels> user = UserProfileModels().obs;
  Dio dio = Dio();
  @override
  void onInit() async {
    await getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    try {
      isLoading(true);
      String apiKey = await getToken();
      dio.options.headers['apiKey'] = apiKey.toString();

      final response = await dio.get(userProfile);

      if (response.statusCode == 200) {
        log(response.data.toString());
        error.value = '';
        user.value = UserProfileModels.fromJson(response.data);
      } else if (response.statusCode == 401) {
        error.value = 'token';
      } else if (response.statusCode == 402) {
        error.value = 'not admin';
      } else {
        error.value = response.data['cause'].toString();
      }
    } catch (e) {
      log(e.toString());
      error.value = serverError;
    }
    isLoading(false);
    update();
  }

  Future<void> putUser(String tip, String data) async {
    try {
      isLoading(true);
      String apiKey = await getToken();
      dio.options.headers['apiKey'] = apiKey.toString();

      final response = await dio.put(userProfile, data: {
        tip: data,
      });

      if (response.statusCode == 200) {
        log(response.data.toString());
        error.value = '';
      } else if (response.statusCode == 401) {
        error.value = 'token';
      } else if (response.statusCode == 402) {
        error.value = 'not admin';
      } else {
        error.value = response.data['cause'].toString();
      }
    } catch (e) {
      log(e.toString());
      error.value = serverError;
    }
    isLoading(false);
    update();
  }

  Future<void> putImage(String tip, String filename, String filepath,
      BuildContext context) async {
    try {
      isLoading(true);
      String apiKey = await getToken();
      dio.options.headers['apiKey'] = apiKey.toString();

      final response = await dio.put(userProfile,
          data: formdara.FormData.fromMap({
            tip: await multipart.MultipartFile.fromFile(filepath,
                filename: filename),
          }));

      if (response.statusCode == 200) {
        log(response.data.toString());
        error.value = '';
      } else if (response.statusCode == 401) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false);
        mess(context, 'الرجاء اعادة تسجيل الدخول', Colors.red);
      } else if (response.statusCode == 402) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NotAdmine()),
            (route) => false);
        mess(context, 'ليس لديك صلاحية الوصول', Colors.red);
      }
    } catch (e) {
      log(e.toString());
      error.value = serverError;
    }
    isLoading(false);
    update();
  }
}

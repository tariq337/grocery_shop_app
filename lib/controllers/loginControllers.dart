import 'dart:convert';

import 'package:admindukanv1/constant.dart';
import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';
import 'dart:developer';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxString apiKey = ''.obs;
  RxString error = ''.obs;

  Future<void> LoginController(String phone, String password) async {
    try {
      isLoading(true);
      final response = await Dio()
          .post(loginUrl, data: {'phoneNumber': phone, 'password': password});

      switch (response.statusCode) {
        case 200:
          log(response.data['apiKey'].toString());
          apiKey.value = response.data['apiKey'].toString();
          break;
        case 400:
          error.value = response.data['cause'];
          break;
        default:
          error.value = serverError + response.statusCode.toString();
          break;
      }
    } catch (e) {
      log(e.toString());
      error.value = serverError;
    }
    isLoading(false);
    update();
  }

  Future<void> regesterController(String username, String groceryName,
      String phone, String password, String location) async {
    try {
      isLoading(true);

      final response = await Dio().post(registerUrl, data: {
        'userName': username,
        'groceryName': groceryName,
        'phoneNumber': phone,
        'password': password,
        'location': location,
      });

      switch (response.statusCode) {
        case 200:
          apiKey.value = jsonDecode(response.data)['apiKey'].toString();
          error.value = '';
          log(apiKey.value);
          break;
        case 400:
          error.value = jsonDecode(response.data)['cause'];
          break;
        default:
          error.value = serverError + response.statusCode.toString();
          break;
      }
    } catch (e) {
      log(e.toString());
      error.value = serverError;
    }
    isLoading(false);
    update();
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/models/data.dart';
import 'package:admindukanv1/services/user_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/src/form_data.dart' as formdara;
import 'package:dio/src/multipart_file.dart' as multipart;

class ProductsControllers extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isListLoading = false.obs;
  RxDouble sendData = 0.0.obs;
  Rx<DataVeiw> productsList = DataVeiw().obs;
  Rx<String> error = ''.obs;
  Rx<String> errordelet = ''.obs;
  Dio dio = Dio();

  @override
  void onInit() async {
    await getdataController();
    super.onInit();
  }

  Future<void> getdataController() async {
    try {
      isListLoading(true);
      String apiKey = await getToken();
      dio.options.headers['apiKey'] = apiKey.toString();

      var response = await dio.get(
        getdataUrl,
      );

      log(response.data.toString());

      if (response.statusCode == 200) {
        log(response.data.toString());
        error.value = '';
        productsList.value = DataVeiw.fromJson(response.data);
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
    isListLoading(false);
    update();
  }

  Future<void> addController(
      String name, String price, File productImage) async {
    try {
      log('addController ');

      isLoading(true);
      String apiKey = await getToken();
      dio.options.headers['apiKey'] = apiKey.toString();

      String fileName = productImage.path.split('/').last;
      formdara.FormData data = formdara.FormData.fromMap({
        "name": name,
        "price": price,
        "productImage": await multipart.MultipartFile.fromFile(
            productImage.path,
            filename: fileName),
      });

      var response = await dio.post(passdataUrl, data: data,
          onSendProgress: (int? sent, int? total) {
        sendData.value = (sent! / total!);
        log(sendData.toString());
      });
      if (response.statusCode == 200) {
        error.value = '';
      } else if (response.statusCode == 401) {
        error.value = 'token';
      } else if (response.statusCode == 402) {
        error.value = 'not admin';
      } else {
        error.value = response.data['cause'].toString();
      }
      /*
      var formData = FormData.fromMap({
        'name': 'wendux',
        'age': 25,
        'file':
            await MultipartFile.fromFile('./text.txt', filename: 'upload.txt'),
      });

      
      response = await dio.post("/info", data: formData);


      String apiKey = await getToken();

      log('put');

      var stream = http.ByteStream(productImage.openRead());
      stream.cast();

      var length = await productImage.length();

      var request = http.MultipartRequest('POST', Uri.parse(passdataUrl));
      request.headers.addAll({'apiKey': apiKey});
      request.fields['name'] = name;
      request.fields['price'] = price;

      var multiport = http.MultipartFile('productImage', stream, length);

      request.files.add(multiport);

      var response = await request.send();

      if (response.statusCode == 200) {
        error.value = '';
      } else {
        error.value = response.toString();
      }*/
    } catch (e) {
      error.value = serverError;
    }
    sendData.value = 0;
    isLoading(false);
    update();
  }

  Future<void> putController(
      String name, String price, String id, File productImage) async {
    try {
      log('put');

      isLoading(true);
      String fileName = productImage.path.split('/').last;
      formdara.FormData data = formdara.FormData.fromMap({
        "name": name,
        "price": price,
        "productImage": await multipart.MultipartFile.fromFile(
            productImage.path,
            filename: fileName),
      });

      final response = await dio.put(passdataUrl + '/$id', data: data,
          onSendProgress: (int? sent, int? total) {
        sendData.value = (sent! / total!) * 100;
        log(sendData.value.toString());
      });
      if (response.statusCode == 200) {
        error.value = '';
      } else if (response.statusCode == 401) {
        error.value = 'token';
      } else if (response.statusCode == 402) {
        error.value = 'not admin';
      } else {
        error.value = response.data['cause'].toString();
      }
    } catch (e) {
      error.value = serverError;
    }
    sendData.value = 0;

    isLoading(false);
    update();
  }

  Future<void> putPriceController(
    String price,
    String id,
  ) async {
    try {
      log('put');

      isLoading(true);
      final response = await dio.put(passdataUrl + '/$id', data: {
        "price": price,
      });

      if (response.statusCode == 200) {
        error.value = '';
      } else if (response.statusCode == 401) {
        error.value = 'token';
      } else if (response.statusCode == 402) {
        error.value = 'not admin';
      } else {
        error.value = response.data['cause'].toString();
      }
    } catch (e) {
      error.value = serverError;
    }
    isLoading(false);
    update();
  }

  Future<void> DeleteController(String id) async {
    try {
      isListLoading(true);
      final response = await dio.delete(
        passdataUrl + '/$id',
      );

      if (response.statusCode == 200) {
        errordelet.value = '';
      } else {
        errordelet.value = response.data['cause'];
      }
    } catch (e) {
      errordelet.value = serverError;
    }
    isListLoading(false);
    update();
  }

  void errorrefresh() {
    error.value = '';
  }
}

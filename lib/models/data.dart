import 'dart:developer';

import 'package:admindukanv1/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DataVeiw {
  List<Details>? details;

  DataVeiw({this.details});

  DataVeiw.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }
}

class Details {
  int? id;
  String? name;
  int? price;

  Details({
    this.id,
    this.name,
    this.price,
  });

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }
}

Future<dynamic> getdata(String apiKey) async {
  try {
    final response = await http.get(
      Uri.parse(getdataUrl),
      headers: {'apiKey': apiKey},
    );

    if (response.statusCode == 200) {
      log(json.decode(response.body).toString());
      return DataVeiw.fromJson(json.decode(response.body));
    } else {
      log(json.decode(response.body).toString());
      return 'error';
    }
  } catch (e) {
    log(e.toString());
    return 'error';
  }
}

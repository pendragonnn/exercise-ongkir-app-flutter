import 'dart:convert';

import 'package:cek_ongkir/app/data/models/ongkir_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();
  RxString provAsalId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString provTujuanId = "0".obs;
  RxString cityTujuanId = "0".obs;
  RxString codeKurir = "".obs;
  RxBool isLoading = false.obs;

  List<Ongkir> ongkosKirim = [];

  void cekOngkir() async {
    if (provAsalId != "0" &&
        provTujuanId != "0" &&
        cityAsalId != "0" &&
        cityTujuanId != "0" &&
        codeKurir != "0" &&
        beratC.text != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          body: {
            "origin": cityAsalId.value,
            "destination": cityTujuanId.value,
            "weight": beratC.text,
            "courier": codeKurir.value,
          },
          headers: {
            "key": "${dotenv.env['API_KEY']}",
            "content-type": "application/x-www-form-urlencoded",
          },
        );
        isLoading.value = false;
        List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;
        ongkosKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
            title: "Ongkos Kirim",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ongkosKirim
                  .map(
                    (e) => ListTile(
                      title: Text(
                        "${e.service!.toUpperCase()}",
                      ),
                      subtitle: Text("${e.cost![0].value}"),
                    ),
                  )
                  .toList(),
            ));
      } catch (e) {
        print(e);
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat mengecek ongkos kirim",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Data input belum lengkap",
      );
    }
  }
}
